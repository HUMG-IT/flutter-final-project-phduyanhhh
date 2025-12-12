import 'dart:convert';
import 'package:shelf_router/shelf_router.dart';

import '../domain/repositories/user_repository.dart';
import 'package:shelf/shelf.dart';

class UserController {
  final UserRepository repository;

  Router get router {
    final router = Router();

    router.post('/register', register);
    router.post('/login', login);

    return router;
  }

  UserController(this.repository);

  // POST /register
  Future<Response> register(Request req) async {
    final body = jsonDecode(await req.readAsString());

    final user = await repository.register(
      body['username'],
      body['email'],
      body['password'],
    );

    return Response.ok(
      jsonEncode(user.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  }

  // POST /login
  Future<Response> login(Request req) async {
    final body = jsonDecode(await req.readAsString());

    final user = await repository.login(body['username'], body['password']);

    if (user == null) {
      return Response.forbidden(jsonEncode({"message": "Invalid login"}));
    }

    return Response.ok(
      jsonEncode(user.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
  }
}
