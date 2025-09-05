import 'package:drivio_sarthi/network/ApiService.dart';
import 'package:drivio_sarthi/network/WebService.dart';

class AuthRepo {
  /// Sign up repo function
  Future<dynamic> signUpRepo(
    String fullname,
    String mobileNumber,
    email,
    referral,
  ) async {
    var response;

    Map<String, dynamic> bodyMap = {
      "fullname": fullname,
      "email": email,
      "mobileNumber": mobileNumber,
      "referral": referral,
    };
    print("sign up repo body :-- $bodyMap");
    print("sign up repo header :-- ${await DioServices().getDefaultHeader()}");
    try {
      response = await DioServices().postMethod(
        WebService().signUpApi,
        bodyMap,
        await DioServices().getDefaultHeader(),
      );
      print("response signup repo :-- $response");
    } catch (e) {
      print("sign-up repo error :-- $e");
    }
    return response;
  }

  /// verify repo function
  Future<dynamic> verifyOtpRepo(
    String mobileNumber,
    String otp,
    String type,
  ) async {
    var response;

    Map<String, dynamic> bodyMap = {
      "mobileNumber": mobileNumber,
      "otp": otp,
      "type": type,
    };
    print("body map :-- $bodyMap");
    try {
      response = await DioServices().postMethod(
        WebService().verifyTopApi,
        bodyMap,
        await DioServices().getDefaultHeader(),
      );
      print("response verify repo :-- $response");
    } catch (e) {
      print("response verify rep error :-- $e");
    }
    return response;
  }

  /// login repo function
  Future<dynamic> loginRepo(String mobileNumber) async {
    var response;

    Map<String, dynamic> bodyMap = {"mobileNumber": mobileNumber};
    print("body map :-- $bodyMap");
    try {
      response = await DioServices().postMethod(
        WebService().loginApi,
        bodyMap,
        await DioServices().getDefaultHeader(),
      );
      print("response login repo :-- $response");
    } catch (e) {
      print("login repo error :-- $e");
    }
    return response;
  }

  /// logout repo function
  Future<dynamic> logoutRepo() async {
    var response;
    try {
      response = await DioServices().getMethod(
        WebService().logoutApi,
        await DioServices().getDefaultHeader(),
      );
      print("response logout repo :-- $response");
    } catch (e) {
      print("error logout repo :-- $e");
    }
    return response;
  }

  /// Update profile repo function
  Future<dynamic> updateProfileRepo(
    String id,
    String fullname,
    String email,
    String mobileNumber,
  ) async {
    var response;

    Map<String, dynamic> bodyMap = {
      "id" : id,
      "fullname" : fullname,
      "email" : email,
      "mobileNumber" : mobileNumber,
    };
    print("update profile body :-- $bodyMap");

    try {
      response = await DioServices().putMethod(
        WebService().editProfileApi,
        bodyMap,
        await DioServices().getDefaultHeader(),
      );
      print("response:-- $response");
    } catch (e) {
      print("update profile repo error :-- $e");
    }
    return response;
  }
}
