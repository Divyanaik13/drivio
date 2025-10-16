import '../network/ApiService.dart';
import '../network/WebService.dart';
import '../utils/CommonFunctions.dart';

class ProfileRepo {
  /// update/edit profile function
  Future<dynamic> updateUserDataRepo(
      String id, fullname, mobileNumber, email) async {
    CommonFunctions().showLoader();
    var response;
    Map<String, dynamic> bodyMap = {
      "fullname": fullname,
      "email": email,
      "mobileNumber": mobileNumber,
    };
    print("update Profile Repo bodyMap :-- $bodyMap");
    try {
      var header = await DioServices().getAllHeaders();
      response = await DioServices()
          .putMethod("${WebService().editProfileApi}?id=$id", bodyMap, header);
      print("edit profile header :-- $header");
      print("url :-- ${WebService().editProfileApi}?id=$id");
      print("update Profile Repo response :-- $response");
    } catch (e) {
      print("update Profile Repo response :-- $e");
    }
    return response;
  }

  /// Update profile (image)
  Future<dynamic> updateProfileRepo(String filePath) async {
    var response;
    try {
      const String keyName = "file";
      final header = await DioServices().getAllHeaders();

      List<String> filePaths = [];
      if (filePath.isNotEmpty) {
        filePaths.add(filePath);
      }

      Map<String, dynamic> body = {};

      response = await DioServices().multipartPostMethod(
        WebService().updateProfile,
        keyName,
        filePaths,
        body,
        header,
      );

      print("updateProfileRepo response :-- $response");
    } catch (e, st) {
      print("update profile repo error :-- $e\n$st");
    }
    return response;
  }

  /// Delete user repo function
  Future<Map<String, dynamic>> deleteUserRepo(String id) async {
    var response;
    var header = await DioServices().getAllHeaders();
    try {
      response = await DioServices()
          .deleteData("${WebService().deleteUserApi}?id=$id", header, null);
      print("delete header :-- $header");
      print("delete user repo response:-- $response");
      return response;
    } catch (e) {
      print("Delete user repo error :-- $e");
      return {"success": 0, "message": "Exception: $e", "error": {}};
    }
  }

  /// Profile number otp verify
  Future<dynamic> profileNumberOtpVerify() async {
    var response;
    Map<String, dynamic> bodyMap = {};
    try {
      response = await DioServices().postMethod(WebService().profileOtpVerify,
          bodyMap, await DioServices().getAllHeaders());
    } catch (e) {
      print("profileNumberOtpVerify error : $e");
    }
  }

  /// Create car collection repo function
  Future<dynamic> addCarRepo(String carname, ownername, carNumber,
      transmissionType, mobileNumber) async {
    var response;
    Map<String, dynamic> bodyMap = {
      "carname": carname,
      "ownername": ownername,
      "carNumber": carNumber,
      "transmissionType": transmissionType,
      "mobileNumber": mobileNumber,
    };
    try {
      response = await DioServices().postMethod(
          WebService().addCarApi, bodyMap, await DioServices().getAllHeaders());
      print("add Car Repo response :-- $response");
    } catch (e) {
      print("add Car Repo error : $e");
    }
    return response;
  }

  /// get all car collection repo function
  Future<dynamic> getCarCollectionRepo(String mobileNumber) async {
    var response;
    var url = "${WebService().getAllCarCollection}?mobileNumber=$mobileNumber";
    try {
      response = await DioServices().getMethod(
        url, await DioServices().getAllHeaders(),
      );
      print("get Car Collection Repo :-- $response");
    } catch (e) {
      print("error get Car Collection Repo :-- $e");
    }
    return response;
  }



}
