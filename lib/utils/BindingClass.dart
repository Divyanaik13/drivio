import 'package:get/get.dart';

import '../controllers/AuthController.dart';
import '../repositories/AuthRepository.dart';

class BindingClass extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<AuthController>(() => AuthController(AuthRepo()), fenix: true);

  }
}
