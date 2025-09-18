import 'package:drivio_sarthi/repositories/HomeRepository.dart';
import 'package:drivio_sarthi/repositories/ProfileRepository.dart';
import 'package:get/get.dart';
import '../controllers/AuthController.dart';
import '../controllers/HomeController.dart';
import '../controllers/profileController.dart';
import '../repositories/AuthRepository.dart';

class BindingClass extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController(AuthRepo()), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(ProfileRepo()), fenix: true);
    Get.lazyPut<HomeController>(() => HomeController(HomeRepo()), fenix: true);
  }
}
