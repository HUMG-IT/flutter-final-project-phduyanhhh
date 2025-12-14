import 'package:dio/dio.dart';
import '../../domain/entities/post.dart';
import '../models/post_model.dart';

class PostRepositoryImpl {
  final Dio client;

  PostRepositoryImpl(this.client);

  Future<List<PostModel>> getPosts() async {
    final res = await client.get('/posts');

    return (res.data as List).map((e) => PostModel.fromJson(e)).toList();
  }

  Future<List<PostModel>> getPostsByAuthorId(int authorId) async {
    final res = await client.get('/posts/author/$authorId');

    return (res.data as List).map((e) => PostModel.fromJson(e)).toList();
  }

  Future<Post> createPost({
    required String title,
    required String content,
    required int authorId,
    required List<String> images,
  }) async {
    final res = await client.post(
      '/posts',
      data: {
        'title': title,
        'content': content,
        'authorId': authorId,
        'images': images,
      },
    );

    return PostModel.fromJson(res.data);
  }

  Future<PostModel?> getPostById(int id) async {
    final res = await client.get('/posts/$id');
    if (res.data == null) return null;
    return PostModel.fromJson(res.data);
  }

  Future<PostModel?> updatePost(
    int id,
    String title,
    String content,
    List<String> images,
  ) async {
    final res = await client.put(
      '/posts/$id',
      data: {
        'title': title,
        'content': content,
        'images': images,
      },
    );

    if (res.data == null) return null;
    return PostModel.fromJson(res.data);
  }

  Future<void> deletePost(int id) async {
    await client.delete('/posts/$id');
  }
}
