// domain/usecases/login_user.dart
import 'package:flutter_project/src/features/user/domain/entities/user.dart';
import 'package:flutter_project/src/features/user/domain/repositories/user_repository.dart';

class LoginUser {
  final UserRepository repository;

  LoginUser(this.repository);

  Future<User> call(String username, String password) {
    return repository.login(username, password);
  }
}
