import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../domain/repositories/user_repository.dart';

class UserController {
  final UserRepository repository;

  UserController(this.repository);

  Router get router {
    final router = Router();

    router.get('/users', _getUsers);
    router.post('/users', _createUser);

    return router;
  }

  Future<Response> _getUsers(Request req) async {
    final users = await repository.getUsers();

    final data = users.map((u) => u.toJson()).toList();

    return Response.ok(
      jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<Response> _createUser(Request req) async {
    final body = await req.readAsString();
    final data = jsonDecode(body);
    await repository.createUser(data['name']);
    return Response.ok('User created');
  }
}
