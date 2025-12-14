import 'package:backend/src/domain/repositories/dtos/posts/post_response_dto.dart';

import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/post_datasource.dart';

class PostRepositoryImpl implements PostRepository {
  final PostDataSource ds;

  PostRepositoryImpl(this.ds);

  @override
  Future<Post> createPost(
    String title,
    String content,
    int authorId,
    List<String> images,
  ) async {
    final data = await ds.createPost(title, content, authorId, images);

    return Post(
      id: data['id'],
      title: data['title'],
      content: data['content'],
      authorId: data['author_id'],
      images: List<String>.from(data['images'] ?? []),
      createdAt: data['created_at'],
    );
  }

  @override
  Future<List<PostResponseDto>> getPosts() async {
    final list = await ds.getPosts();

    return list.map((e) {
      return PostResponseDto(
        id: e['id'],
        title: e['title'],
        content: e['content'],
        authorId: e['author_id'],
        authorName: e['author_name'],
        images: List<String>.from(e['images'] ?? []),
        createdAt: e['created_at'],
      );
    }).toList();
  }

  @override
  Future<Post?> getPostById(int id) async {
    final data = await ds.getPostById(id);
    if (data == null) return null;

    return Post(
      id: data['id'],
      title: data['title'],
      content: data['content'],
      authorId: data['author_id'],
      images: List<String>.from(data['images'] ?? []),
      createdAt: data['created_at'],
    );
  }

  @override
  Future<List<PostResponseDto>> getPostsByAuthorId(int authorId) async {
    final list = await ds.getPostsByAuthorId(authorId);

    return list.map((e) {
      return PostResponseDto(
        id: e['id'],
        title: e['title'],
        content: e['content'],
        authorId: e['author_id'],
        authorName: e['author_name'],
        images: List<String>.from(e['images'] ?? []),
        createdAt: e['created_at'],
      );
    }).toList();
  }

  @override
  Future<Post?> updatePost(
    int id,
    String title,
    String content,
    List<String> images,
  ) async {
    final data = await ds.updatePost(id, title, content, images);
    if (data == null) return null;

    return Post(
      id: data['id'],
      title: data['title'],
      content: data['content'],
      authorId: data['author_id'],
      images: List<String>.from(data['images'] ?? []),
      createdAt: data['created_at'],
    );
  }

  @override
  Future<void> deletePost(int id) => ds.deletePost(id);
}
