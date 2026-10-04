import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:bookswap_login/app/theme.dart';
import 'package:bookswap_login/core/services/photo_picker.dart';
import 'package:bookswap_login/core/services/photo_uploader.dart';
import 'package:bookswap_login/core/services/public_profile_service.dart';
import 'package:bookswap_login/core/utils/photo_url.dart';
import 'package:bookswap_login/features/authentication/presentation/providers/profile_photo_providers.dart';
import 'package:bookswap_login/shared/widgets/member_avatar.dart';
import 'support/test_app.dart';

const cloud = 'o9we0m6d';
const photo =
    'https://res.cloudinary.com/$cloud/image/upload/v1/bookswap/avatars/abc.jpg';

class FakePicker implements PhotoPicker {
  PickedPhoto? result = PickedPhoto(Uint8List.fromList([1, 2, 3]), 'me.jpg');
  Object? error;
  final asked = <PhotoSource>[];

  @override
  Future<PickedPhoto?> pick(PhotoSource source) async {
    asked.add(source);
    if (error != null) throw error!;
    return result;
  }
}

class FakeUploader implements PhotoUploader {
  FakeUploader({this.available = true});
  @override
  final bool available;
  String url = photo;
  PhotoUploadFailure? failure;
  final uploads = <String>[];

  @override
  Future<String> upload(Uint8List bytes, {required String filename}) async {
    uploads.add(filename);
    if (failure != null) throw failure!;
    return url;
  }
}

/// Records what would be saved instead of touching Firestore.
class RecordingProfiles extends PublicProfileService {
  RecordingProfiles() : super(FakeFirebaseFirestore());
  final saved = <String>[];
  Object? error;

  @override
  Future<void> updatePhoto(String uid, String url) async {
    if (error != null) throw error!;
    saved.add('$uid=$url');
  }
}

class _Adapter implements HttpClientAdapter {
  _Adapter(this.respond);
  final Future<ResponseBody> Function(RequestOptions) respond;
  RequestOptions? last;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    last = options;
    return respond(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody json(Object body, int status) => ResponseBody.fromString(
  jsonEncode(body),
  status,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
  },
);

void main() {
  group('photo URLs', () {
    test('only images on this app\'s own Cloudinary account count', () {
      expect(isOurPhotoUrl(photo), isTrue);
      expect(isOurPhotoUrl(null), isFalse);
      expect(isOurPhotoUrl(''), isFalse);
      expect(
        isOurPhotoUrl('https://res.cloudinary.com/someone-else/image/upload/x'),
        isFalse,
      );
      expect(
        isOurPhotoUrl('https://evil.example/$cloud/image/upload/x'),
        isFalse,
      );
      expect(
        isOurPhotoUrl('http://res.cloudinary.com/$cloud/image/upload/x'),
        isFalse,
        reason: 'must be https',
      );
    });

    test('avatars ask Cloudinary for a small face-centred copy', () {
      final url = avatarUrl(photo, size: 88)!;
      expect(
        url,
        'https://res.cloudinary.com/$cloud/image/upload/'
        'c_fill,g_face,w_192,h_192,f_auto,q_auto/v1/bookswap/avatars/abc.jpg',
      );
    });

    test('sizes step up so similar avatars share one image', () {
      String px(double size) => RegExp(
        r'w_(\d+)',
      ).firstMatch(avatarUrl(photo, size: size)!)!.group(1)!;
      expect(px(22), '64');
      expect(px(28), '64');
      expect(px(36), '96');
      expect(px(88), '192');
      expect(px(1000), '480', reason: 'capped');
    });

    test('no usable photo gives no URL', () {
      expect(avatarUrl(null, size: 40), isNull);
      expect(avatarUrl('', size: 40), isNull);
      expect(avatarUrl('https://example.com/a.jpg', size: 40), isNull);
    });
  });

  group('Cloudinary uploader', () {
    final bytes = Uint8List.fromList(List.filled(100, 7));

    CloudinaryPhotoUploader uploaderFor(
      Future<ResponseBody> Function(RequestOptions) respond, {
      String cloudName = cloud,
      String preset = 'bookswap_avatars',
      _Adapter? adapter,
    }) {
      final dio = Dio()..httpClientAdapter = adapter ?? _Adapter(respond);
      return CloudinaryPhotoUploader(
        dio,
        cloudName: cloudName,
        uploadPreset: preset,
      );
    }

    test(
      'posts the file with the unsigned preset and returns the URL',
      () async {
        final adapter = _Adapter((_) async => json({'secure_url': photo}, 200));
        final result = await uploaderFor(
          (_) async => json({}, 200),
          adapter: adapter,
        ).upload(bytes, filename: 'me.jpg');
        expect(result, photo);
        final request = adapter.last!;
        expect(
          request.uri.toString(),
          'https://api.cloudinary.com/v1_1/$cloud/image/upload',
        );
        final form = request.data as FormData;
        expect(
          form.fields.map((f) => '${f.key}=${f.value}'),
          contains('upload_preset=bookswap_avatars'),
        );
        expect(form.files.single.key, 'file');
        expect(form.files.single.value.filename, 'me.jpg');
      },
    );

    test('a rejected upload says the photo was not accepted', () async {
      final up = uploaderFor(
        (_) async => json({
          'error': {'message': 'bad'},
        }, 400),
      );
      await expectLater(
        up.upload(bytes, filename: 'x.jpg'),
        throwsA(
          isA<PhotoUploadFailure>().having(
            (e) => e.message,
            'message',
            contains('not accepted'),
          ),
        ),
      );
    });

    test('being offline suggests checking the connection', () async {
      final up = uploaderFor(
        (o) async => throw DioException(
          requestOptions: o,
          type: DioExceptionType.connectionError,
        ),
      );
      await expectLater(
        up.upload(bytes, filename: 'x.jpg'),
        throwsA(
          isA<PhotoUploadFailure>().having(
            (e) => e.message,
            'message',
            contains('connection'),
          ),
        ),
      );
    });

    test('a URL from another account in the reply is refused', () async {
      final up = uploaderFor(
        (_) async => json({
          'secure_url': 'https://res.cloudinary.com/other/image/upload/a.jpg',
        }, 200),
      );
      await expectLater(
        up.upload(bytes, filename: 'x.jpg'),
        throwsA(isA<PhotoUploadFailure>()),
      );
    });

    test('a reply without a URL is a failure', () async {
      final up = uploaderFor((_) async => json({'ok': true}, 200));
      await expectLater(
        up.upload(bytes, filename: 'x.jpg'),
        throwsA(isA<PhotoUploadFailure>()),
      );
    });

    test('a photo over 5 MB is refused without a request', () async {
      final adapter = _Adapter((_) async => json({'secure_url': photo}, 200));
      final up = uploaderFor((_) async => json({}, 200), adapter: adapter);
      await expectLater(
        up.upload(Uint8List(maxPhotoBytes + 1), filename: 'big.jpg'),
        throwsA(
          isA<PhotoUploadFailure>().having(
            (e) => e.message,
            'message',
            contains('too large'),
          ),
        ),
      );
      expect(adapter.last, isNull);
    });

    test('with no account configured it is unavailable', () async {
      final up = uploaderFor((_) async => json({}, 200), cloudName: '');
      expect(up.available, isFalse);
      await expectLater(
        up.upload(bytes, filename: 'x.jpg'),
        throwsA(isA<PhotoUploadFailure>()),
      );
    });
  });

  group('changing the photo', () {
    late FakePicker picker;
    late FakeUploader uploader;
    late RecordingProfiles profiles;
    late ProfilePhotoActions actions;

    setUp(() {
      picker = FakePicker();
      uploader = FakeUploader();
      profiles = RecordingProfiles();
      actions = ProfilePhotoActions(
        picker: picker,
        uploader: uploader,
        profiles: profiles,
        userId: 'me',
      );
    });

    test('picks, uploads and saves the URL', () async {
      expect(await actions.change(PhotoSource.gallery), isTrue);
      expect(picker.asked, [PhotoSource.gallery]);
      expect(uploader.uploads, ['me.jpg']);
      expect(profiles.saved, ['me=$photo']);
    });

    test('backing out changes nothing', () async {
      picker.result = null;
      expect(await actions.change(PhotoSource.camera), isFalse);
      expect(uploader.uploads, isEmpty);
      expect(profiles.saved, isEmpty);
    });

    test('a failed upload keeps the current photo', () async {
      uploader.failure = const PhotoUploadFailure('nope');
      await expectLater(
        actions.change(PhotoSource.gallery),
        throwsA(isA<PhotoUploadFailure>()),
      );
      expect(profiles.saved, isEmpty);
    });

    test('a picker error explains about permissions', () async {
      picker.error = StateError('denied');
      await expectLater(
        actions.change(PhotoSource.camera),
        throwsA(
          isA<PhotoUploadFailure>().having(
            (e) => e.message,
            'message',
            contains('allowed'),
          ),
        ),
      );
    });

    test('a failed save is reported', () async {
      profiles.error = StateError('offline');
      await expectLater(
        actions.change(PhotoSource.gallery),
        throwsA(
          isA<PhotoUploadFailure>().having(
            (e) => e.message,
            'message',
            contains('save'),
          ),
        ),
      );
    });

    test('removing saves an empty URL', () async {
      await actions.remove();
      expect(profiles.saved, ['me=']);
    });
  });

  group('public profile storage', () {
    test('the photo URL round-trips through Firestore', () async {
      final db = FakeFirebaseFirestore();
      final service = PublicProfileService(db);
      await service.updatePhoto('u1', photo);
      final doc = await db.collection('public_profiles').doc('u1').get();
      expect(PublicProfile.fromDoc('u1', doc.data()).photoUrl, photo);
      await service.updatePhoto('u1', '');
      final cleared = await db.collection('public_profiles').doc('u1').get();
      expect(PublicProfile.fromDoc('u1', cleared.data()).photoUrl, '');
    });

    test('a profile without a photo has none', () {
      expect(PublicProfile.fromDoc('u1', {'firstName': 'A'}).photoUrl, isNull);
    });
  });

  group('avatar widget', () {
    Widget host(Widget child) => MaterialApp(
      theme: buildTheme(Brightness.light),
      home: Scaffold(body: child),
    );

    testWidgets('shows the initial when there is no photo', (tester) async {
      await tester.pumpWidget(host(const AvatarCircle(name: 'rafi')));
      expect(find.text('R'), findsOneWidget);
      expect(
        tester.widget<CircleAvatar>(find.byType(CircleAvatar)).foregroundImage,
        isNull,
      );
    });

    testWidgets('an empty name gets a question mark', (tester) async {
      await tester.pumpWidget(host(const AvatarCircle(name: '  ')));
      expect(find.text('?'), findsOneWidget);
    });

    testWidgets('shows the resized photo, with the initial underneath', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(const AvatarCircle(name: 'Rafi', photoUrl: photo, radius: 44)),
      );
      final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
      expect(
        (avatar.foregroundImage as NetworkImage).url,
        avatarUrl(photo, size: 88),
      );
      expect(find.text('R'), findsOneWidget, reason: 'fallback while loading');
    });

    testWidgets('a photo from elsewhere is ignored', (tester) async {
      await tester.pumpWidget(
        host(
          const AvatarCircle(
            name: 'Rafi',
            photoUrl: 'https://example.com/a.jpg',
          ),
        ),
      );
      expect(
        tester.widget<CircleAvatar>(find.byType(CircleAvatar)).foregroundImage,
        isNull,
      );
    });

    testWidgets('is hidden from screen readers', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(host(const AvatarCircle(name: 'Rafi')));
      expect(find.bySemanticsLabel('R'), findsNothing);
      handle.dispose();
    });
  });

  group('screens', () {
    late Directory hiveDir;

    setUpAll(() async {
      hiveDir = await initTestHive();
    });

    tearDownAll(() => closeTestHive(hiveDir));

    Future<(FakePicker, FakeUploader, RecordingProfiles)> openProfile(
      WidgetTester tester, {
      String? myPhoto,
      bool available = true,
    }) async {
      tester.view.physicalSize = const Size(390, 1800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final picker = FakePicker();
      final uploader = FakeUploader(available: available);
      final profiles = RecordingProfiles();
      await signInWithFixtures(
        tester,
        overrides: [
          photoPickerProvider.overrideWithValue(picker),
          photoUploaderProvider.overrideWithValue(uploader),
          publicProfileServiceProvider.overrideWithValue(profiles),
          allPublicProfilesProvider.overrideWith(
            (ref) => Stream.value({
              'demo-reader': PublicProfile(
                uid: 'demo-reader',
                photoUrl: myPhoto,
              ),
              'owner-2': const PublicProfile(uid: 'owner-2', photoUrl: photo),
            }),
          ),
        ],
      );
      GoRouter.of(tester.element(find.byType(Scaffold).first)).go('/profile');
      await tester.pumpAndSettle();
      return (picker, uploader, profiles);
    }

    testWidgets('choosing a photo uploads and saves it', (tester) async {
      final (picker, uploader, profiles) = await openProfile(tester);
      await tester.tap(find.byKey(const Key('changePhoto')));
      await tester.pumpAndSettle();
      expect(find.text('Take a photo'), findsOneWidget);
      expect(find.text('Choose from gallery'), findsOneWidget);
      expect(find.text('Remove photo'), findsNothing, reason: 'no photo yet');

      await tester.tap(find.byKey(const Key('photoGallery')));
      await tester.pumpAndSettle();
      expect(picker.asked, [PhotoSource.gallery]);
      expect(uploader.uploads, hasLength(1));
      expect(profiles.saved, ['demo-reader=$photo']);
      expect(find.text('Photo updated.'), findsOneWidget);
    });

    testWidgets('the camera option asks the picker for the camera', (
      tester,
    ) async {
      final (picker, _, _) = await openProfile(tester);
      await tester.tap(find.byKey(const Key('changePhoto')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('photoCamera')));
      await tester.pumpAndSettle();
      expect(picker.asked, [PhotoSource.camera]);
    });

    testWidgets('a failed upload says why and saves nothing', (tester) async {
      final (_, uploader, profiles) = await openProfile(tester);
      uploader.failure = const PhotoUploadFailure(
        "Couldn't upload the photo. Check your connection and try again.",
      );
      await tester.tap(find.byKey(const Key('changePhoto')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('photoGallery')));
      await tester.pumpAndSettle();
      expect(find.textContaining('Check your connection'), findsOneWidget);
      expect(profiles.saved, isEmpty);
    });

    testWidgets('backing out of the picker is silent', (tester) async {
      final (picker, uploader, profiles) = await openProfile(tester);
      picker.result = null;
      await tester.tap(find.byKey(const Key('changePhoto')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('photoGallery')));
      await tester.pumpAndSettle();
      expect(uploader.uploads, isEmpty);
      expect(profiles.saved, isEmpty);
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('an existing photo can be removed', (tester) async {
      final (_, _, profiles) = await openProfile(tester, myPhoto: photo);
      await tester.tap(find.byKey(const Key('changePhoto')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('photoRemove')));
      await tester.pumpAndSettle();
      expect(profiles.saved, ['demo-reader=']);
      expect(find.text('Photo removed.'), findsOneWidget);
    });

    testWidgets('the profile shows your own photo', (tester) async {
      await openProfile(tester, myPhoto: photo);
      final avatars = tester
          .widgetList<AvatarCircle>(find.byType(AvatarCircle))
          .where((a) => a.radius == 44);
      expect(avatars.single.photoUrl, photo);
    });

    testWidgets('without Cloudinary set up it says so', (tester) async {
      final (picker, _, _) = await openProfile(tester, available: false);
      await tester.tap(find.byKey(const Key('changePhoto')));
      await tester.pumpAndSettle();
      expect(find.text('Photos are not set up yet.'), findsOneWidget);
      expect(find.text('Take a photo'), findsNothing);
      expect(picker.asked, isEmpty);
    });

    testWidgets('other members\' photos show in the forum', (tester) async {
      await openProfile(tester);
      GoRouter.of(tester.element(find.byType(Scaffold).first)).go('/forum');
      await tester.pumpAndSettle();
      final withPhoto = tester
          .widgetList<AvatarCircle>(find.byType(AvatarCircle))
          .where((a) => a.photoUrl == photo);
      expect(withPhoto, isNotEmpty, reason: 'Rafi (owner-2) wrote the post');
    });

    testWidgets('and on the leaderboard', (tester) async {
      await openProfile(tester);
      GoRouter.of(
        tester.element(find.byType(Scaffold).first),
      ).go('/leaderboard');
      await tester.pumpAndSettle();
      final withPhoto = tester
          .widgetList<AvatarCircle>(find.byType(AvatarCircle))
          .where((a) => a.photoUrl == photo);
      expect(withPhoto, isNotEmpty);
    });
  });
}
