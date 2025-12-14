import 'dart:io';
import 'package:backend/src/presentation/root_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'src/presentation/user_controller.dart';
import 'src/infrastructure/injector.dart';

Future<void> startServer() async {
  final injector = await Injector.create();
  final userController = UserController(injector.userRepository);

  // lấy router từ UserController
  final Router router = createRootRouter(injector);

  // Middleware CORS
  Response _cors(Response response) => response.change(
    headers: {
      ...response.headers,
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept',
    },
  );

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware((innerHandler) {
        return (Request request) async {
          if (request.method == 'OPTIONS') {
            return Response.ok(
              '',
              headers: {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods':
                    'GET, POST, PUT, DELETE, OPTIONS',
                'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept',
              },
            );
          }
          final response = await innerHandler(request);
          return response.change(
            headers: {...response.headers, 'Access-Control-Allow-Origin': '*'},
          );
        };
      })
      .addHandler(router);

  final server = await io.serve(handler, '0.0.0.0', 8080);
  print('Server running at http://${server.address.host}:${server.port}');
}
