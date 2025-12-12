import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({required super.id, required super.name});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(id: map['id'], name: map['name']);
  }
}
