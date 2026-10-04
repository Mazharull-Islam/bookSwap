import 'dart:io';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:bookswap_login/features/forum/data/repositories/firestore_forum_repository.dart';
import 'package:bookswap_login/features/forum/domain/entities/forum_post.dart';
import 'package:bookswap_login/features/forum/domain/entities/forum_reply.dart';
import 'package:bookswap_login/features/forum/domain/entities/forum_report.dart';
import 'package:bookswap_login/features/forum/domain/repositories/forum_repository.dart';
import 'package:bookswap_login/features/forum/presentation/providers/forum_providers.dart';
import 'support/test_app.dart';
import 'package:bookswap_login/features/forum/data/models/forum_report_dto.dart';

ForumReport report(
  String postId, {
  String? replyId,
  String by = 'u1',
  String reason = 'spam',
  int at = 0,
}) => ForumReport(
  id: ForumReport.idFor(postId, replyId, by),
  postId: postId,
  replyId: replyId,
  reporterId: by,
  reason: reason,
  createdAtMs: at,
);

/// Records what the UI asks the repository to do.
class RecordingForumRepository implements ForumRepository {
  final calls = <String>[];

  @override
  Future<void> reportPost(
    String postId,
    String userId,
    ForumReportReason reason,
  ) async => calls.add('reportPost $postId ${reason.name}');

  @override
  Future<void> reportReply(
    String postId,
    String replyId,
    String userId,
    ForumReportReason reason,
  ) async => calls.add('reportReply $postId/$replyId ${reason.name}');

  @override
  Future<void> deletePost(String postId) async =>
      calls.add('deletePost $postId');

  @override
  Future<void> deleteReply(String postId, String replyId) async =>
      calls.add('deleteReply $postId/$replyId');

  @override
  Future<void> dismissReports(ReportedTarget target) async =>
      calls.add('dismiss ${target.key}');

  @override
  Future<void> removeReported(ReportedTarget target) async =>
      calls.add('remove ${target.key}');

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}

void main() {
  group('who sees what', () {
    bool visible({
      List<String> reportedBy = const [],
      String author = 'a',
      String me = 'm',
      bool moderator = false,
    }) => visibleToMember(
      reportedBy: reportedBy,
      hidden: reportedBy.length >= forumHideThreshold,
      authorId: author,
      memberId: me,
      moderator: moderator,
    );

    test('one report from someone else does not hide it', () {
      expect(visible(reportedBy: ['x']), isTrue);
      expect(visible(reportedBy: ['x', 'y']), isTrue);
    });

    test('enough distinct reports hide it from ordinary members', () {
      expect(visible(reportedBy: ['x', 'y', 'z']), isFalse);
    });

    test('its author and moderators still see a hidden item', () {
      const three = ['x', 'y', 'z'];
      expect(visible(reportedBy: three, author: 'm'), isTrue);
      expect(visible(reportedBy: three, moderator: true), isTrue);
    });

    test('a member who reported it no longer sees it, even as a moderator', () {
      expect(visible(reportedBy: ['m']), isFalse);
      expect(visible(reportedBy: ['m'], moderator: true), isFalse);
    });

    test('the hide threshold is more than one report', () {
      expect(forumHideThreshold, greaterThan(1));
    });
  });

  group('grouping reports', () {
    test('groups by target, most reported first, with a reason summary', () {
      final targets = groupReports([
        report('p1', by: 'a', reason: 'spam'),
        report('p1', by: 'b', reason: 'spam'),
        report('p1', by: 'c', reason: 'abuse'),
        report('p2', by: 'a', at: 9),
        report('p1', replyId: 'r1', by: 'a'),
      ]);
      expect(targets.map((t) => t.key), ['p1', 'p2', 'p1_r1']);
      expect(targets.first.reports, hasLength(3));
      expect(targets.first.reasonSummary, 'Spam ×2, Abuse or harassment');
      expect(targets.last.isReply, isTrue);
    });
  });

  group('repository', () {
    late FakeFirebaseFirestore db;
    late FirestoreForumRepository repo;

    setUp(() async {
      db = FakeFirebaseFirestore();
      repo = FirestoreForumRepository(db);
    });

    Future<ForumPost> post() => repo.createPost(
      authorId: 'au',
      authorName: 'Au',
      title: 'T',
      body: 'B',
    );

    test(
      'reporting records the reporter and a report with its reason',
      () async {
        final p = await post();
        await repo.reportPost(p.id, 'u1', ForumReportReason.abuse);
        final saved = (await repo.fetchPost(p.id))!;
        expect(saved.reportedBy, ['u1']);
        final reports = (await db.collection('forum_reports').get()).docs;
        expect(reports, hasLength(1));
        final r = ForumReportDto.parse(reports.single.data());
        expect(r.reason, 'abuse');
        expect(r.postId, p.id);
        expect(r.isReply, isFalse);
        expect(r.reporterId, 'u1');
      },
    );

    test('reporting a reply keys the report to the reply', () async {
      final p = await post();
      final r = await repo.createReply(
        postId: p.id,
        authorId: 'au',
        authorName: 'Au',
        body: 'hi',
      );
      await repo.reportReply(p.id, r.id, 'u1', ForumReportReason.spam);
      final doc = (await db.collection('forum_reports').get()).docs.single;
      expect(ForumReportDto.parse(doc.data()).targetKey, '${p.id}_${r.id}');
      expect((await repo.fetchReply(p.id, r.id))!.reportedBy, ['u1']);
    });

    test('dismissing clears the reports and restores the post', () async {
      final p = await post();
      for (final u in ['a', 'b', 'c']) {
        await repo.reportPost(p.id, u, ForumReportReason.spam);
      }
      expect((await repo.fetchPost(p.id))!.isHidden, isTrue);
      final target = groupReports(await repo.watchReports().first).single;
      await repo.dismissReports(target);
      expect((await repo.fetchPost(p.id))!.reportedBy, isEmpty);
      expect((await db.collection('forum_reports').get()).docs, isEmpty);
    });

    test('removing deletes the post and its reports', () async {
      final p = await post();
      await repo.reportPost(p.id, 'a', ForumReportReason.other);
      final target = groupReports(await repo.watchReports().first).single;
      await repo.removeReported(target);
      expect(await repo.fetchPost(p.id), isNull);
      expect((await db.collection('forum_reports').get()).docs, isEmpty);
    });

    test('removing a reply keeps the post and fixes its reply count', () async {
      final p = await post();
      final r = await repo.createReply(
        postId: p.id,
        authorId: 'au',
        authorName: 'Au',
        body: 'hi',
      );
      expect((await repo.fetchPost(p.id))!.replyCount, 1);
      await repo.reportReply(p.id, r.id, 'a', ForumReportReason.spam);
      final target = groupReports(await repo.watchReports().first).single;
      await repo.removeReported(target);
      expect(await repo.fetchReply(p.id, r.id), isNull);
      expect((await repo.fetchPost(p.id))!.replyCount, 0);
    });

    test(
      'clearing reports for an item already deleted does not fail',
      () async {
        final p = await post();
        await repo.reportPost(p.id, 'a', ForumReportReason.spam);
        final target = groupReports(await repo.watchReports().first).single;
        await repo.deletePost(p.id);
        await repo.dismissReports(target);
        expect((await db.collection('forum_reports').get()).docs, isEmpty);
      },
    );

    test('authors delete their own reply and the count drops', () async {
      final p = await post();
      final r = await repo.createReply(
        postId: p.id,
        authorId: 'au',
        authorName: 'Au',
        body: 'hi',
      );
      await repo.deleteReply(p.id, r.id);
      expect(await repo.fetchReply(p.id, r.id), isNull);
      expect((await repo.fetchPost(p.id))!.replyCount, 0);
    });

    test('moderator status comes from the moderators collection', () async {
      expect(await repo.watchIsModerator('m1').first, isFalse);
      await db.collection('moderators').doc('m1').set({'since': 1});
      expect(await repo.watchIsModerator('m1').first, isTrue);
      expect(await repo.watchIsModerator('someone-else').first, isFalse);
    });
  });

  group('screens', () {
    late Directory hiveDir;

    setUpAll(() async {
      hiveDir = await initTestHive();
    });

    tearDownAll(() => closeTestHive(hiveDir));

    final mine = fixturePost.copyWith(authorId: 'demo-reader');
    final hiddenMine = mine.copyWith(reportedBy: ['x', 'y', 'z']);
    final othersReply = fixtureReply; // by owner-3
    final myReply = fixtureReply.copyWith(authorId: 'demo-reader');

    Future<RecordingForumRepository> openPost(
      WidgetTester tester, {
      ForumPost? post,
      ForumReply? reply,
      bool moderator = false,
    }) async {
      tester.view.physicalSize = const Size(390, 1800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final repo = RecordingForumRepository();
      final shown = post ?? fixturePost;
      await signInWithFixtures(
        tester,
        overrides: [
          forumRepositoryProvider.overrideWithValue(repo),
          isModeratorProvider.overrideWith((ref) => Stream.value(moderator)),
          forumFeedProvider.overrideWithValue([shown]),
          forumPostProvider.overrideWith((ref, id) => Stream.value(shown)),
          forumRepliesProvider.overrideWith(
            (ref, id) => [reply ?? othersReply],
          ),
        ],
      );
      GoRouter.of(tester.element(find.byType(Scaffold).first)).go('/forum');
      await tester.pumpAndSettle();
      await tester.tap(find.text(shown.title));
      await tester.pumpAndSettle();
      return repo;
    }

    testWidgets('reporting someone else\'s post asks for a reason', (
      tester,
    ) async {
      final repo = await openPost(tester);
      expect(find.byTooltip('Delete post'), findsNothing);
      await tester.tap(find.byTooltip('Report'));
      await tester.pumpAndSettle();
      // Can't submit without choosing why.
      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, 'Report'))
            .onPressed,
        isNull,
      );
      await tester.tap(find.text('Spam'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Report'));
      await tester.pumpAndSettle();
      expect(repo.calls, ['reportPost post-1 spam']);
      expect(
        find.text('Reported. You will no longer see this post.'),
        findsOneWidget,
      );
    });

    testWidgets('cancelling the report dialog reports nothing', (tester) async {
      final repo = await openPost(tester);
      await tester.tap(find.byTooltip('Report'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(repo.calls, isEmpty);
    });

    testWidgets('you cannot report your own post or reply, but can delete', (
      tester,
    ) async {
      await openPost(tester, post: mine, reply: myReply);
      expect(find.byTooltip('Report'), findsNothing);
      expect(find.byTooltip('Report this reply'), findsNothing);
      expect(find.byTooltip('Delete post'), findsOneWidget);
      expect(find.byTooltip('Delete this reply'), findsOneWidget);
    });

    testWidgets('deleting your post confirms first', (tester) async {
      final repo = await openPost(tester, post: mine);
      await tester.tap(find.byTooltip('Delete post'));
      await tester.pumpAndSettle();
      expect(find.text('Delete this post?'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(repo.calls, isEmpty);

      await tester.tap(find.byTooltip('Delete post'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
      await tester.pumpAndSettle();
      expect(repo.calls, ['deletePost post-1']);
      expect(find.text('Forum'), findsWidgets);
    });

    testWidgets('deleting your reply asks, then deletes it', (tester) async {
      final repo = await openPost(tester, reply: myReply);
      await tester.tap(find.byTooltip('Delete this reply'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
      await tester.pumpAndSettle();
      expect(repo.calls, ['deleteReply post-1/reply-1']);
    });

    testWidgets('ordinary members cannot delete other people\'s content', (
      tester,
    ) async {
      await openPost(tester);
      expect(find.byTooltip('Delete post'), findsNothing);
      expect(find.byTooltip('Remove post'), findsNothing);
      expect(find.byTooltip('Delete this reply'), findsNothing);
    });

    testWidgets('moderators can remove other people\'s post and reply', (
      tester,
    ) async {
      final repo = await openPost(tester, moderator: true);
      expect(find.byTooltip('Remove post'), findsOneWidget);
      await tester.tap(find.byTooltip('Delete this reply'));
      await tester.pumpAndSettle();
      expect(find.text('Remove this reply?'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilledButton, 'Remove'));
      await tester.pumpAndSettle();
      expect(repo.calls, ['deleteReply post-1/reply-1']);
    });

    testWidgets('a hidden post is flagged for its author', (tester) async {
      await openPost(tester, post: hiddenMine);
      expect(find.text('Under review'), findsWidgets);
    });

    group('moderation queue', () {
      final target = ReportedTarget([
        report('post-1', by: 'a', reason: 'spam'),
        report('post-1', by: 'b', reason: 'abuse'),
      ]);

      Future<RecordingForumRepository> openQueue(
        WidgetTester tester, {
        bool moderator = true,
        ForumPost? content,
        List<ReportedTarget>? targets,
      }) async {
        tester.view.physicalSize = const Size(390, 1800);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final repo = RecordingForumRepository();
        await signInWithFixtures(
          tester,
          overrides: [
            forumRepositoryProvider.overrideWithValue(repo),
            isModeratorProvider.overrideWith((ref) => Stream.value(moderator)),
            reportedTargetsProvider.overrideWith(
              (ref) => Stream.value(targets ?? [target]),
            ),
            reportedContentProvider.overrideWith(
              (ref, t) async => (post: content, reply: null),
            ),
          ],
        );
        GoRouter.of(
          tester.element(find.byType(Scaffold).first),
        ).go('/moderation');
        await tester.pumpAndSettle();
        return repo;
      }

      testWidgets('is closed to ordinary members', (tester) async {
        await openQueue(tester, moderator: false);
        expect(find.text('Moderators only.'), findsOneWidget);
        expect(find.text('Dismiss reports'), findsNothing);
      });

      testWidgets('shows the reported content and why', (tester) async {
        await openQueue(tester, content: fixturePost);
        expect(find.text('Post · 2 reports'), findsOneWidget);
        expect(find.text('Spam, Abuse or harassment'), findsOneWidget);
        expect(find.text(fixturePost.title), findsOneWidget);
      });

      testWidgets('dismissing restores the item', (tester) async {
        final repo = await openQueue(tester, content: fixturePost);
        await tapVisible(tester, find.text('Dismiss reports'));
        expect(repo.calls, ['dismiss post-1']);
      });

      testWidgets('removing asks first', (tester) async {
        final repo = await openQueue(tester, content: fixturePost);
        await tapVisible(tester, find.widgetWithText(FilledButton, 'Remove'));
        expect(find.text('Remove this post?'), findsOneWidget);
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();
        expect(repo.calls, isEmpty);

        await tapVisible(tester, find.widgetWithText(FilledButton, 'Remove'));
        await tester.tap(find.widgetWithText(FilledButton, 'Remove').last);
        await tester.pumpAndSettle();
        expect(repo.calls, ['remove post-1']);
      });

      testWidgets('an item deleted by its author can just be cleared', (
        tester,
      ) async {
        final repo = await openQueue(tester);
        expect(find.textContaining('no longer exists'), findsOneWidget);
        expect(find.widgetWithText(FilledButton, 'Remove'), findsNothing);
        await tapVisible(tester, find.text('Clear'));
        expect(repo.calls, ['dismiss post-1']);
      });

      testWidgets('an empty queue says so', (tester) async {
        await openQueue(tester, targets: const []);
        expect(find.text('Nothing reported. All clear.'), findsOneWidget);
      });
    });

    group('More page', () {
      Future<void> openMore(
        WidgetTester tester, {
        required bool moderator,
      }) async {
        await signInWithFixtures(
          tester,
          overrides: [
            isModeratorProvider.overrideWith((ref) => Stream.value(moderator)),
          ],
        );
        GoRouter.of(tester.element(find.byType(Scaffold).first)).go('/more');
        await tester.pumpAndSettle();
      }

      testWidgets('lists Moderation for moderators', (tester) async {
        await openMore(tester, moderator: true);
        expect(find.text('Moderation'), findsOneWidget);
      });

      testWidgets('hides Moderation from everyone else', (tester) async {
        await openMore(tester, moderator: false);
        expect(find.text('Moderation'), findsNothing);
      });
    });
  });
}
