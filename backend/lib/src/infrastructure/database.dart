import 'package:postgres/postgres.dart';

class Database {
  static Future<PostgreSQLConnection> connect() async {
    final conn = PostgreSQLConnection(
      'localhost',
      5433,
      'fluuter_final_project',
      username: 'postgres',
      password: 'secret',
    );

    await conn.open();
    print('📦 PostgreSQL connected');
    return conn;
  }
}
