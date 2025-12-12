import '../entities/user.dart';

abstract class UserRepository {
  Future<List<User>> getUsers();
  Future<void> createUser(String name);
}
