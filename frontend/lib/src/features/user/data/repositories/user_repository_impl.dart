import 'package:dio/dio.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final Dio client;

  UserRepositoryImpl(this.client);

  @override
  Future<User> register(String username, String email, String password) async {
    final response = await client.post(
      '/register',
      data: {
        'username': username,
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return UserModel.fromJson(response.data);
    } else {
      throw Exception('Register failed: ${response.statusMessage}');
    }
  }

  @override
  Future<User> login(String username, String password) async {
    final response = await client.post(
      '/login',
      data: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data);
    } else {
      throw Exception('Login failed: ${response.statusMessage}');
    }
  }
}
