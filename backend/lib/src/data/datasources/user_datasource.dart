import 'package:postgres/postgres.dart';

class UserDataSource {
  final PostgreSQLConnection conn;

  UserDataSource(this.conn);

  Future<List<Map<String, dynamic>>> getUsers() async {
    final results = await conn.mappedResultsQuery('SELECT * FROM users');

    return results.map((row) => row['users']!).toList();
  }

  Future<void> createUser(String name) async {
    await conn.query(
      'INSERT INTO users (name) VALUES (@name)',
      substitutionValues: {'name': name},
    );
  }
}
