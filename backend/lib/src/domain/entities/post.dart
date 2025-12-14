class Post {
  final int id;
  final String title;
  final String content;
  final int authorId;
  final List<String> images;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.images,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'authorId': authorId,
      'images': images,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
