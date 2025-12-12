import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_datasource.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource ds;

  UserRepositoryImpl(this.ds);

  @override
  Future<List<User>> getUsers() async {
    final data = await ds.getUsers();
    return data.map((e) => UserModel.fromMap(e)).toList();
  }

  @override
  Future<void> createUser(String name) => ds.createUser(name);
}
