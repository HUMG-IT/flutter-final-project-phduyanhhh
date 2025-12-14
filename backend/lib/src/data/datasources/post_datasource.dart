import 'package:postgres/postgres.dart';

class PostDataSource {
  final PostgreSQLConnection conn;

  PostDataSource(this.conn);

  Future<Map<String, dynamic>> createPost(
    String title,
    String content,
    int authorId,
    List<String> images,
  ) async {
    final result = await conn.mappedResultsQuery(
      '''
      INSERT INTO posts (title, content, author_id, images)
      VALUES (@title, @content, @authorId, @images)
      RETURNING *
      ''',
      substitutionValues: {
        'title': title,
        'content': content,
        'authorId': authorId,
        'images': images,
      },
    );

    return result.first['posts']!;
  }

  Future<List<Map<String, dynamic>>> getPosts() async {
    final result = await conn.query('''
    SELECT 
      p.id,
      p.title,
      p.content,
      p.author_id,
      p.images,
      p.created_at,
      u.username AS author_name
    FROM posts p
    JOIN users u ON u.id = p.author_id
    ORDER BY p.id DESC
    ''');

    return result.map((row) {
      return {
        'id': row[0],
        'title': row[1],
        'content': row[2],
        'author_id': row[3],
        'images': row[4],
        'created_at': row[5],
        'author_name': row[6],
      };
    }).toList();
  }

  Future<Map<String, dynamic>?> getPostById(int id) async {
    final result = await conn.mappedResultsQuery(
      'SELECT * FROM posts WHERE id = @id LIMIT 1',
      substitutionValues: {'id': id},
    );

    if (result.isEmpty) return null;

    final post = result.first['posts']!;
    post['images'] = List<String>.from(post['images'] ?? []);
    return post;
  }

  Future<void> deletePost(int id) async {
    await conn.query(
      'DELETE FROM posts WHERE id = @id',
      substitutionValues: {'id': id},
    );
  }

  Future<Map<String, dynamic>?> updatePost(
    int id,
    String title,
    String content,
    List<String> images,
  ) async {
    final result = await conn.query(
      '''
    UPDATE posts
    SET
      title = @title,
      content = @content,
      images = @images
    WHERE id = @id
    RETURNING
      id,
      title,
      content,
      author_id,
      images,
      created_at
    ''',
      substitutionValues: {
        'id': id,
        'title': title,
        'content': content,
        'images': images,
      },
    );

    if (result.isEmpty) return null;

    final row = result.first;
    return {
      'id': row[0],
      'title': row[1],
      'content': row[2],
      'author_id': row[3],
      'images': row[4] ?? [],
      'created_at': row[5],
    };
  }

  Future<List<Map<String, dynamic>>> getPostsByAuthorId(int authorId) async {
    final result = await conn.query(
      '''
    SELECT 
      p.id,
      p.title,
      p.content,
      p.author_id,
      p.images,
      p.created_at,
      u.username AS author_name
    FROM posts p
    JOIN users u ON u.id = p.author_id
    WHERE p.author_id = @authorId
    ORDER BY p.id DESC
    ''',
      substitutionValues: {'authorId': authorId},
    );

    return result.map((row) {
      return {
        'id': row[0],
        'title': row[1],
        'content': row[2],
        'author_id': row[3],
        'images': row[4] ?? [],
        'created_at': row[5],
        'author_name': row[6],
      };
    }).toList();
  }
}
