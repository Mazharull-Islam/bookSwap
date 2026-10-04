import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/forum_providers.dart';
import '../widgets/create_post_dialog.dart';
import '../widgets/forum_post_tile.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/back_to_more_button.dart';

class ForumPage extends ConsumerWidget {
  const ForumPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(forumFeedProvider);
    return Scaffold(
      appBar: AppBar(
        leading: const BackToMoreButton(),
        title: const Text('Forum'),
      ),
      body: posts.isEmpty
          ? const EmptyState(
              icon: Icons.forum_outlined,
              message: 'No discussions yet — start one!',
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 88),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return ForumPostTile(
                  post: post,
                  onTap: () => context.push('/forum/post/${post.id}'),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showCreatePostDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('New post'),
      ),
    );
  }
}
