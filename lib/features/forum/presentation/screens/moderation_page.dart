import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/app_colors.dart';
import '../../../../shared/widgets/section_heading.dart';
import '../../domain/entities/forum_post.dart';
import '../../domain/entities/forum_reply.dart';
import '../../domain/entities/forum_report.dart';
import '../providers/forum_providers.dart';
import '../widgets/forum_post_tile.dart' show formatForumDate;
import '../widgets/report_dialog.dart';
import '../../../../shared/widgets/feedback.dart';

/// Moderators only (the More page doesn't link here for anyone else, and the
/// rules refuse non-moderators regardless).
class ModerationPage extends ConsumerWidget {
  const ModerationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moderator = ref.watch(isModeratorProvider).valueOrNull ?? false;
    final reports = ref.watch(reportedTargetsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Moderation')),
      body: !moderator
          ? const Center(child: Text('Moderators only.'))
          : reports.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text("Couldn't load reports. Try again shortly."),
                ),
              ),
              data: (targets) => targets.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          'Nothing reported. All clear.',
                          style: TextStyle(color: context.colors.textMuted),
                        ),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        SectionHeading(
                          '${targets.length} reported '
                          '${targets.length == 1 ? 'item' : 'items'}',
                        ),
                        const SizedBox(height: 8),
                        for (final target in targets)
                          _ReportedCard(
                            key: ValueKey(target.key),
                            target: target,
                          ),
                      ],
                    ),
            ),
    );
  }
}

class _ReportedCard extends ConsumerWidget {
  const _ReportedCard({super.key, required this.target});
  final ReportedTarget target;

  Future<void> _dismiss(BuildContext context, WidgetRef ref) async {
    await ref.read(dismissReportsProvider)(target);
    if (context.mounted) {
      showMessage(context, 'Reports dismissed. It is visible again.');
    }
  }

  Future<void> _remove(BuildContext context, WidgetRef ref) async {
    final what = target.isReply ? 'reply' : 'post';
    if (!await confirmRemoval(context, what: what, asModerator: true)) return;
    await ref.read(removeReportedProvider)(target);
    if (context.mounted) {
      showMessage(context, 'Removed the $what.');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = ref.watch(reportedContentProvider(target));
    final count = target.reports.length;
    final ForumPost? post = content.valueOrNull?.post;
    final ForumReply? reply = content.valueOrNull?.reply;
    final gone = content.hasValue && post == null && reply == null;
    final author = post?.authorName ?? reply?.authorName;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${target.isReply ? 'Reply' : 'Post'} · '
              '$count ${count == 1 ? 'report' : 'reports'}',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 2),
            Text(
              target.reasonSummary,
              style: TextStyle(color: context.colors.danger),
            ),
            const SizedBox(height: 10),
            if (content.isLoading)
              const LinearProgressIndicator()
            else if (gone)
              Text(
                'This item no longer exists (its author may have deleted it).',
                style: TextStyle(color: context.colors.textMuted),
              )
            else ...[
              if (post != null)
                Text(
                  post.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              Text(post?.body ?? reply?.body ?? ''),
              const SizedBox(height: 4),
              Text(
                '$author · ${formatForumDate((post?.createdAtMs ?? reply?.createdAtMs) ?? 0)}',
                style: TextStyle(fontSize: 12, color: context.colors.textMuted),
              ),
            ],
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                if (!gone)
                  TextButton(
                    onPressed: () =>
                        context.push('/forum/post/${target.postId}'),
                    child: Text(target.isReply ? 'Open thread' : 'Open post'),
                  ),
                OutlinedButton(
                  onPressed: () => _dismiss(context, ref),
                  child: Text(gone ? 'Clear' : 'Dismiss reports'),
                ),
                if (!gone)
                  FilledButton(
                    onPressed: () => _remove(context, ref),
                    child: const Text('Remove'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
