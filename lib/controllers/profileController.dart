import 'dart:io';

import 'package:drivio_sarthi/utils/CommonFunctions.dart';
import 'package:get/get.dart';
import '../model/CarCollectionModel.dart';
import '../repositories/ProfileRepository.dart';
import '../utils/LocalStorage.dart';
import '../utils/RouteHelper.dart';

class ProfileController extends GetxController {
  final ProfileRepo _profileRepo;

  ProfileController(this._profileRepo);

  LocalStorage ls = LocalStorage();
  var imageFile = Rxn<File>();
  var profileImageUrl = "".obs;
  var calCollectionModel = Rxn<CarCollectionModel>();
  var car = Rxn<Car>();


  /// update/edit profile function
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
 /// Update profile (image)
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
 /// Delete api function
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

  /// Add car api function
  Future<dynamic> addCarApi(String carname, ownername, carNumber,
      transmissionType, mobileNumber) async {
    CommonFunctions().showLoader();
    var response;
    try {
      response = await _profileRepo.addCarRepo(carname, ownername, carNumber,
          transmissionType, mobileNumber);
      print("response add car :-- $response");
      CommonFunctions().hideLoader();
      final resData = response?.data;

      if (resData != null && resData['success'] == 1) {
        print("add car success");

        final carData = resData['data']['car'];
        // Return data to previous screen instead of navigating
        Get.back(result: carData);
      }
    } catch (e) {
      print("add car Api error :-- $e");
      CommonFunctions().hideLoader();
    }
    return response;
  }

  /// Get all car collection api function
  Future<dynamic> getCarCollectionApi(String mobileNumber) async {
    CommonFunctions().showLoader();
    var response;
    try {
      response = await _profileRepo.getCarCollectionRepo(mobileNumber);
      print("response get car collection :-- ${response?.data}");
      CommonFunctions().hideLoader();

      if (response != null && response.data != null) {
        var resData = response.data;

        if (resData["success"] == 1) {
          print("get car collection success");

          // Parse JSON using your CarCollectionModel
          calCollectionModel.value = CarCollectionModel.fromJson(resData);

          // extract list of cars
          var cars = calCollectionModel.value!.data.cars;
          print("Total cars fetched: ${cars.length}");

          // store first car (optional)
          if (cars.isNotEmpty) {
            car.value = cars.first;
            print("First car: ${car.value!.carname}");
          }

          return cars;
        } else {
          print("get car collection failed :-- ${resData['message']}");
        }
      }
    } catch (e) {
      print("get car collection Api error :-- $e");
      CommonFunctions().hideLoader();
    }

    return [];
  }

}
