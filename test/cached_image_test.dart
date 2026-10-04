import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bookswap_login/app/theme.dart';
import 'package:bookswap_login/core/utils/cached_image.dart';
import 'package:bookswap_login/features/books/presentation/widgets/book_cover_image.dart';
import 'package:bookswap_login/shared/widgets/member_avatar.dart';

const cover = 'https://covers.openlibrary.org/b/id/123-M.jpg';
const photo =
    'https://res.cloudinary.com/o9we0m6d/image/upload/v1/bookswap/avatars/a.jpg';

Widget host(Widget child) => MaterialApp(
  theme: buildTheme(Brightness.light),
  home: Scaffold(
    body: Center(child: SizedBox(width: 100, height: 140, child: child)),
  ),
);

void main() {
  tearDown(() => diskImageCacheEnabled = false);

  group('image provider', () {
    test('uses the on-disk cache when enabled', () {
      diskImageCacheEnabled = true;
      final provider = cachedImage(cover);
      expect(provider, isA<CachedNetworkImageProvider>());
      expect((provider as CachedNetworkImageProvider).url, cover);
    });

    test('falls back to a plain network image when disabled', () {
      diskImageCacheEnabled = false;
      final provider = cachedImage(cover);
      expect(provider, isA<NetworkImage>());
      expect((provider as NetworkImage).url, cover);
    });

    test('the test setup really does turn the cache off by default', () {
      expect(diskImageCacheEnabled, isFalse);
    });
  });

  group('book covers', () {
    testWidgets('are loaded through the cache', (tester) async {
      diskImageCacheEnabled = true;
      await tester.pumpWidget(host(const BookCoverImage(url: cover)));
      final image = tester.widget<Image>(find.byType(Image));
      expect(image.image, isA<CachedNetworkImageProvider>());
      expect((image.image as CachedNetworkImageProvider).url, cover);
    });

    testWidgets('show a plain tile while loading, not the no-cover icon', (
      tester,
    ) async {
      await tester.pumpWidget(host(const BookCoverImage(url: cover)));
      expect(find.byIcon(Icons.menu_book_outlined), findsNothing);
    });

    testWidgets('fall back to the icon when the cover cannot load', (
      tester,
    ) async {
      // flutter_test answers every network request with an error.
      await tester.pumpWidget(host(const BookCoverImage(url: cover)));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.menu_book_outlined), findsOneWidget);
    });

    testWidgets('a book with no cover shows the icon straight away', (
      tester,
    ) async {
      await tester.pumpWidget(host(const BookCoverImage(url: null)));
      expect(find.byIcon(Icons.menu_book_outlined), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    });
  });

  group('avatars', () {
    testWidgets('are loaded through the cache too', (tester) async {
      diskImageCacheEnabled = true;
      await tester.pumpWidget(
        host(const AvatarCircle(name: 'Rafi', photoUrl: photo)),
      );
      final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
      expect(avatar.foregroundImage, isA<CachedNetworkImageProvider>());
    });
  });
}
