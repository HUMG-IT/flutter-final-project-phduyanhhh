import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/src/features/post/presentation/widgets/edit_post_dialog.dart';

import '../../../user/presentation/bloc/user_bloc.dart';
import '../../../user/presentation/bloc/user_state.dart';
import '../../../post/data/models/post_model.dart';
import '../../../post/data/repositories/post_repository_impl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<List<PostModel>> _futurePosts;

  void _loadPosts(int userId) {
    _futurePosts =
        context.read<PostRepositoryImpl>().getPostsByAuthorId(userId);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userState = context.read<UserBloc>().state;
    if (userState is UserLoaded) {
      _loadPosts(userState.user.id);
    }
  }

  Widget _buildImage(String base64Str) {
    try {
      final bytes = base64Decode(base64Str);
      return Image.memory(
        Uint8List.fromList(bytes),
        width: 100,
        fit: BoxFit.cover,
      );
    } catch (_) {
      return const Icon(Icons.broken_image);
    }
  }

  void _confirmDelete(PostModel post, int userId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xoá bài viết'),
        content: const Text('Bạn có chắc muốn xoá bài viết này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Huỷ'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);

              await context.read<PostRepositoryImpl>().deletePost(post.id);

              setState(() {
                _loadPosts(userId);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã xoá bài viết')),
              );
            },
            child: const Text('Xoá'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userState = context.watch<UserBloc>().state;

    if (userState is! UserLoaded) {
      return const Scaffold(
        body: Center(child: Text('Not logged in')),
      );
    }

    final userId = userState.user.id;

    return Scaffold(
      appBar: AppBar(title: const Text('Trang cá nhân')),
      body: FutureBuilder<List<PostModel>>(
        future: _futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Bạn chưa có bài viết nào'));
          }

          final posts = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: posts.length,
            itemBuilder: (_, i) {
              final post = posts[i];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// TITLE + ACTIONS
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              post.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => EditPostDialog(
                                  postId: post.id,
                                  onUpdated: () {
                                    setState(() {
                                      _loadPosts(userId);
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () => _confirmDelete(post, userId),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),
                      Text(post.content),
                      const SizedBox(height: 8),

                      if (post.images.isNotEmpty)
                        SizedBox(
                          height: 100,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: post.images
                                .map(
                                  (img) => Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: _buildImage(img),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
