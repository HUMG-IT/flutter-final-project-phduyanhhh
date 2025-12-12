import 'database.dart';
import '../data/datasources/user_datasource.dart';
import '../data/repositories_impl/user_repository_impl.dart';
import '../domain/repositories/user_repository.dart';

class Injector {
  final UserRepository userRepository;

  Injector._(this.userRepository);

  static Future<Injector> create() async {
    final db = await Database.connect();
    
    final ds = UserDataSource(db);
    final repo = UserRepositoryImpl(ds);

    return Injector._(repo);
  }
}
