import 'package:drivio_sarthi/utils/CommonFunctions.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../repositories/ProfileRepository.dart';
import '../utils/LocalStorage.dart';
import '../utils/RouteHelper.dart';

class ProfileController extends GetxController {
  final ProfileRepo _profileRepo;


  ProfileController(this._profileRepo);

  Future<dynamic> updateProfileApi(
      String id, fullname, mobileNumber, email) async {
    CommonFunctions().showLoader();
    var response;
    try {
      response = await _profileRepo.updateProfileRepo(
          id, fullname, mobileNumber, email);
      CommonFunctions().hideLoader();
      print("update Profile Api response :-- $response");
    } catch (e) {
      print("update Profile Api error :-- $e");
    }
    return response;
  }

  Future<dynamic> deleteApi(String id) async {
    CommonFunctions().showLoader();
    var response;
    try {
      response = await _profileRepo.deleteUserRepo(id);
      print("response delete :-- $response");
      CommonFunctions().hideLoader();
      if (response != null && response['success'] == 1) {
        print("delete success");

        await LocalStorage.clearUserData();

        Get.offAllNamed(RouteHelper().getLoginScreen());
      }
      print("delete Api response :-- $response");
    } catch (e) {
      print("delete Api error :-- $e");
    }
    return response;
  }


}
