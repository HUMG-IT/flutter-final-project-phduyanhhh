import 'package:flutter_project/src/features/user/domain/entities/user.dart';
import 'package:flutter_project/src/features/user/domain/repositories/user_repository.dart';

class RegisterUser {
  final UserRepository repository;

  RegisterUser(this.repository);

  Future<User> call(String username, String email, String password) {
    return repository.register(username, email, password);
  }
}
