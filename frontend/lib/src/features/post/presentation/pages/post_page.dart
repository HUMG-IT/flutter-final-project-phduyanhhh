import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/src/features/post/data/models/post_model.dart';

import '../../data/repositories/post_repository_impl.dart';
import '../../../user/presentation/bloc/user_bloc.dart';
import '../../../user/presentation/bloc/user_state.dart';
import '../widgets/create_post_dialog.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  late Future<List<PostModel>> _futurePosts;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  void _loadPosts() {
    final postRepo = context.read<PostRepositoryImpl>();
    setState(() {
      _futurePosts = postRepo.getPosts();
    });
  }

  void _showCreatePostDialog(int userId) {
    showDialog(
      context: context,
      builder: (_) => CreatePostDialog(
        userId: userId,
        onCreated: () {
          _loadPosts(); // ✅ CHỈ LOAD DATA
        },
      ),
    );
  }

  void _logout() {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  Widget _buildImage(String base64Str) {
    try {
      final bytes = base64Decode(base64Str);
      return Image.memory(
        Uint8List.fromList(bytes),
        width: 120,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 120,
          color: Colors.grey,
          child: const Icon(Icons.broken_image),
        ),
      );
    } catch (_) {
      // Nếu decode fail
      return Container(
        width: 120,
        color: Colors.grey,
        child: const Icon(Icons.broken_image),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is! UserLoaded) {
          return const Scaffold(
            body: Center(child: Text('Not logged in')),
          );
        }

        final userId = state.user.id;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Posts'),
            actions: [
              PopupMenuButton<_UserMenuAction>(
                onSelected: (value) {
                  switch (value) {
                    case _UserMenuAction.profile:
                      Navigator.pushNamed(context, '/profile');
                      break;
                    case _UserMenuAction.logout:
                      _logout();
                      break;
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: _UserMenuAction.profile,
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Trang cá nhân'),
                    ),
                  ),
                  PopupMenuItem(
                    value: _UserMenuAction.logout,
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Đăng xuất'),
                    ),
                  ),
                ],
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: FlutterLogo(size: 20),
                  ),
                ),
              ),
            ],
          ),
          body: FutureBuilder<List<PostModel>>(
            future: _futurePosts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No posts'));
              }

              final posts = snapshot.data!;

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: posts.length,
                itemBuilder: (_, i) {
                  final post = posts[i];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.authorName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            post.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (post.images.isNotEmpty)
                            SizedBox(
                              height: 120,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: post.images.length,
                                itemBuilder: (_, imgIndex) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: _buildImage(post.images[imgIndex]),
                                  );
                                },
                              ),
                            ),
                          const SizedBox(height: 8),
                          Text(post.content),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showCreatePostDialog(userId),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

enum _UserMenuAction { profile, logout }
