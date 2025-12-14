class Post {
  final int id;
  final String title;
  final String content;
  final int authorId;
  final String authorName;
  final List<String> images;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.images,
  });
}
