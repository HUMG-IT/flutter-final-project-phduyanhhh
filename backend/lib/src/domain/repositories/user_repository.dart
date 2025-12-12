import '../entities/user.dart';

abstract class UserRepository {
  Future<User> register(String username, String email, String password);

  Future<User?> login(String username, String password);
}
