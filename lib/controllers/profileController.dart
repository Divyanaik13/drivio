import 'dart:io';

import 'package:drivio_sarthi/utils/CommonFunctions.dart';
import 'package:get/get.dart';
import '../repositories/ProfileRepository.dart';
import '../utils/LocalStorage.dart';
import '../utils/RouteHelper.dart';

class ProfileController extends GetxController {
  final ProfileRepo _profileRepo;

  ProfileController(this._profileRepo);

  LocalStorage ls = LocalStorage();
  var imageFile = Rxn<File>();
  var profileImageUrl = "".obs;

  Future<dynamic> updateUserDataApi(
      String id, fullname, mobileNumber, email) async {
    CommonFunctions().showLoader();
    var response;
    try {
      response = await _profileRepo.updateUserDataRepo(
          id, fullname, mobileNumber, email);
      CommonFunctions().hideLoader();
      print("update user data Api response :-- $response");
      var data = response.data["data"];
      print("data :-- $data");

      var userId = data["user"]["id"].toString() ?? "";
      var fullName = data["user"]["fullname"].toString() ?? "";
      var editEmail = data["user"]["email"].toString() ?? "";
      var number = data["user"]["mobileNumber"].toString() ?? "";

      print("userId :-- $userId");
      print("fullName :-- $fullName");
      print("email :-- $editEmail");
      print("mobileNumber :-- $number");

      LocalStorage().setStringValue(ls.userId, userId);
      LocalStorage().setStringValue(ls.fullName, fullName);
      LocalStorage().setStringValue(ls.email, editEmail);
      LocalStorage().setStringValue(ls.mobileNumber, number);

      print(
          "edit user data save :-- ${LocalStorage().getStringValue(ls.authToken)}");
    } catch (e) {
      print("update user data error :-- $e");
    }
    return response;
  }

  Future<dynamic> updateProfileApi(String filePath) async {
    CommonFunctions().showLoader();
    try {
      var response = await _profileRepo.updateProfileRepo(filePath);
      CommonFunctions().hideLoader();

      if (response.statusCode == 200) {
        var data = response.data["data"];
        print("data :-- $data");

        var profileImg = data["profile_link"]?.toString() ??
            data["user"]["profileLink"]?.toString() ??
            "";
        if (profileImg.isNotEmpty) {
          ls.setStringValue(ls.profileImg, profileImg);
          print("get profile image from local storage :-- $profileImg");
          profileImageUrl.value = profileImg;
        }
      }

      print("update Profile Api response :-- $response");
      return response;
    } catch (error) {
      CommonFunctions().hideLoader();
      print("update Profile Api error :-- $error");
      return null;
    }
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

        LocalStorage().clearLocalStorage();
        LocalStorage().setBoolValue(LocalStorage().isFirstLaunch, true);
        Get.offAllNamed(RouteHelper().getLoginScreen());
      }
      print("delete Api response :-- $response");
    } catch (e) {
      print("delete Api error :-- $e");
    }
    return response;
  }
}
