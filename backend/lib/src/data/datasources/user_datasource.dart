import 'package:postgres/postgres.dart';
import '../../domain/entities/user.dart';

class UserDataSource {
  final PostgreSQLConnection db;

  UserDataSource(this.db);

  Future<User> createUser(
    String username,
    String email,
    String password,
  ) async {
    final result = await db.query(
      '''
      INSERT INTO users (username, email, password)
      VALUES (@username, @email, @password)
      RETURNING id, username, email
      ''',
      substitutionValues: {
        'username': username,
        'email': email,
        'password': password,
      },
    );

    final row = result.first.toColumnMap();

    return User(id: row['id'], username: row['username'], email: row['email']);
  }

  Future<User?> findUserForLogin(String username, String password) async {
    final result = await db.query(
      '''
      SELECT id, username, email, password
      FROM users
      WHERE username = @username
      ''',
      substitutionValues: {'username': username},
    );

    if (result.isEmpty) return null;

    final row = result.first.toColumnMap();

    if (row['password'] != password) return null;

    return User(id: row['id'], username: row['username'], email: row['email']);
  }
}
