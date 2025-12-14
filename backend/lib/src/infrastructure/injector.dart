import 'database.dart';

import '../data/datasources/user_datasource.dart';
import '../data/repositories_impl/user_repository_impl.dart';
import '../domain/repositories/user_repository.dart';

import '../data/datasources/post_datasource.dart';
import '../data/repositories_impl/post_repository_impl.dart';
import '../domain/repositories/post_repository.dart';

class Injector {
  final UserRepository userRepository;
  final PostRepository postRepository;

  Injector._({required this.userRepository, required this.postRepository});

  static Future<Injector> create() async {
    final db = await Database.connect();

    final userDs = UserDataSource(db);
    final userRepo = UserRepositoryImpl(userDs);

    final postDs = PostDataSource(db);
    final postRepo = PostRepositoryImpl(postDs);

    return Injector._(userRepository: userRepo, postRepository: postRepo);
  }
}
