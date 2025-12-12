import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource ds;

  UserRepositoryImpl(this.ds);

  @override
  Future<User> register(String username, String email, String password) {
    return ds.createUser(username, email, password);
  }

  @override
  Future<User?> login(String username, String password) {
    return ds.findUserForLogin(username, password);
  }
}
