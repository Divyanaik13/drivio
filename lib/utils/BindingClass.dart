import 'package:drivio_sarthi/repositories/HomeRepository.dart';
import 'package:drivio_sarthi/repositories/ProfileRepository.dart';
import 'package:get/get.dart';
import '../controllers/AuthController.dart';
import '../controllers/HomeController.dart';
import '../controllers/PaymentCalController.dart';
import '../controllers/profileController.dart';
import '../network/ApiService.dart';
import '../network/WebService.dart';
import '../repositories/AuthRepository.dart';
import '../repositories/PaymentCalRepo.dart';
import '../repositories/vip_card_repository.dart';

class BindingClass extends Bindings {
  @override
  void dependencies() {

    Get.put(WebService());
    Get.put(DioServices());
    Get.put(VipCardRepository());
    Get.lazyPut<AuthController>(() => AuthController(AuthRepo()), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(ProfileRepo()), fenix: true);
    Get.lazyPut<HomeController>(() => HomeController(HomeRepo()), fenix: true);
    Get.lazyPut<PaymentController>(() => PaymentController(PaymentRepo()), fenix: true);
  }
}
