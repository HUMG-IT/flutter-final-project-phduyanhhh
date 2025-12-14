import 'dart:convert';
import 'package:backend/src/domain/entities/post.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../domain/repositories/post_repository.dart';

class PostController {
  final PostRepository repo;

  PostController(this.repo);

  Router get router {
    final router = Router();

    router.post('/', createPost);
    router.get('/author/<userId>', getPostsByUser);
    router.get('/', getPosts);
    router.get('/<id>', getPostById);
    router.delete('/<id>', deletePost);
    router.put('/<id>', updatePost);

    return router;
  }

  Future<Response> createPost(Request req) async {
    final body = jsonDecode(await req.readAsString());

    final post = await repo.createPost(
      body['title'],
      body['content'],
      body['authorId'],
      List<String>.from(body['images'] ?? []),
    );

    return Response.ok(
      jsonEncode(post.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<Response> getPostsByUser(Request req, String userId) async {
    final posts = await repo.getPostsByAuthorId(int.parse(userId));

    return Response.ok(
      jsonEncode(posts.map((e) => e.toJson()).toList()),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<Response> getPosts(Request req) async {
    final posts = await repo.getPosts();
    return Response.ok(
      jsonEncode(posts.map((e) => e.toJson()).toList()),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<Response> getPostById(Request req, String id) async {
    final post = await repo.getPostById(int.parse(id));
    if (post == null) {
      return Response.notFound('Post not found');
    }
    return Response.ok(jsonEncode(post.toJson()));
  }

  Future<Response> updatePost(Request req, String id) async {
    final postId = int.tryParse(id);
    if (postId == null) {
      return Response(400, body: 'Invalid post id');
    }

    final body = await req.readAsString();
    final data = jsonDecode(body);

    final title = data['title'] as String?;
    final content = data['content'] as String?;
    final images = (data['images'] as List?)?.cast<String>();
    final authorId = data['authorId'] as int?;

    if (authorId == null) {
      return Response(400, body: 'authorId is required');
    }

    final Post? oldPost = await repo.getPostById(postId);
    if (oldPost == null) {
      return Response.notFound('Post not found');
    }

    if (oldPost.authorId != authorId) {
      return Response.forbidden('No permission');
    }

    final updated = await repo.updatePost(
      postId,
      title ?? oldPost.title,
      content ?? oldPost.content,
      images ?? oldPost.images,
    );

    return Response.ok(
      jsonEncode(updated),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<Response> deletePost(Request req, String id) async {
    await repo.deletePost(int.parse(id));
    return Response.ok('Deleted');
  }
}
