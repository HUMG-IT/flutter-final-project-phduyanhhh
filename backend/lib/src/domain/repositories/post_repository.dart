import 'package:backend/src/domain/repositories/dtos/posts/post_response_dto.dart';

import '../entities/post.dart';

abstract class PostRepository {
  Future<Post> createPost(
    String title,
    String content,
    int authorId,
    List<String> images,
  );
  Future<List<PostResponseDto>> getPostsByAuthorId(int authorId);
  Future<List<PostResponseDto>> getPosts();
  Future<Post?> getPostById(int id);
  Future<void> deletePost(int id);
  Future<Post?> updatePost(
    int id,
    String title,
    String content,
    List<String> images,
  );
}
