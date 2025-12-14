// presentation/dtos/post_response_dto.dart
class PostResponseDto {
  final int id;
  final String title;
  final String content;
  final int authorId;
  final String authorName;
  final List<String> images;
  final DateTime createdAt;

  PostResponseDto({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.images,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'authorId': authorId,
    'authorName': authorName,
    'images': images,
    'createdAt': createdAt.toIso8601String(),
  };
}
