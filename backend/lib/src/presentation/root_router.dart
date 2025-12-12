import 'package:shelf_router/shelf_router.dart';

import 'user_controller.dart';
import '../infrastructure/injector.dart';

Router createRootRouter(Injector injector) {
  final router = Router()
    ..mount('/users/', UserController(injector.userRepository).router);

  return router;
}
