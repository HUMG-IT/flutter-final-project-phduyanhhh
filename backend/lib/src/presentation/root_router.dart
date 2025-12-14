import 'package:shelf_router/shelf_router.dart';

import 'user_controller.dart';
import 'post_controller.dart';
import '../infrastructure/injector.dart';

Router createRootRouter(Injector injector) {
  final router = Router()
    ..mount('/', UserController(injector.userRepository).router)
    ..mount('/posts', PostController(injector.postRepository).router);

  return router;
}
