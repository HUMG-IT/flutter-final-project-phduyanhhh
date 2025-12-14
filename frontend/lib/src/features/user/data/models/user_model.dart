import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required int id,
    required String username,
    required String email,
  }) : super(id: id, username: username, email: email);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      username: json['username'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
      };
}
