import 'dart:io';
import 'package:shelf/shelf_io.dart' as io;
import 'src/presentation/user_controller.dart';
import 'src/infrastructure/injector.dart';

Future<void> startServer() async {
  final injector = await Injector.create(); // chờ async
  final userController = UserController(injector.userRepository);

  final handler = userController.router;

  final server = await io.serve(handler, '0.0.0.0', 8080);
  print('Server running at http://${server.address.host}:${server.port}');
}
