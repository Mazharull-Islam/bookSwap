import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme.dart';
import '../providers/forum_providers.dart';
import '../widgets/create_post_dialog.dart';
import '../widgets/forum_post_tile.dart';
import 'post_detail_page.dart';

class ForumPage extends ConsumerWidget {
  const ForumPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(forumFeedProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Forum')),
      body: posts.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.forum_outlined, size: 56, color: forest),
                    const SizedBox(height: 16),
                    const Text(
                      'No discussions yet — start one!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF617065)),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 88),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return ForumPostTile(
                  post: post,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PostDetailPage(postId: post.id),
                    ),
                  ),
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
