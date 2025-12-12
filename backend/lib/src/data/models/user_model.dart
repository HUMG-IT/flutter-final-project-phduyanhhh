import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({required super.id, required super.username, required super.email});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(id: map['id'], username: map['username'], email: map['email']);
  }
}
