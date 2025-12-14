import '../../domain/entities/post.dart';

class PostModel extends Post {
  PostModel({
    required super.id,
    required super.title,
    required super.content,
    required super.authorId,
    required super.authorName,
    required super.images,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      authorId: json['authorId'] ?? 0,
      authorName: json['authorName'] ?? '',
      images: List<String>.from(json['images'] ?? []),
    );
  }
}
