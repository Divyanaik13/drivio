import 'dart:developer';
import 'dart:io';

import 'package:drivio_sarthi/network/ApiService.dart';
import 'package:drivio_sarthi/network/WebService.dart';

class HomeRepo {
  Future<dynamic> searchHistoryListRepo(
      String phoneNumber, int page, limit) async {
    var response;
    try {
      var url =
          "${WebService().getSearchHistoryApi}?user_phoneNumber=$phoneNumber&page=$page&limit=$limit";
      print("Search History url :-- $url");
      response = await DioServices()
          .getMethod(url, await DioServices().getAllHeaders());
      log("Search History repo response :-- $response");
    } catch (e) {
      print("Search History repo error :-- $e");
    }
    return response;
  }

  Future<dynamic> createSearchHistoryRepo(
      String phoneNumber, latitude, longitude, address, dateTime) async {
    var response;
    try {
      Map<String, dynamic> body = {
        "user_phoneNumber": phoneNumber,
        "lateLog": "$latitude,$longitude",
        "address": address,
        "device": Platform.isAndroid ? "android" : "ios",
        "occurred_at": dateTime
      };
      print("createHistoryListRepo body :-- $body");
      response = await DioServices().postMethod(
          WebService().getSearchHistoryApi,
          body,
          await DioServices().getAllHeaders());
      print("createHistoryListRepo response :-- $response");
    } catch (e) {
      print("createHistoryListRepo error :-- $e");
    }
    return response;
  }

  Future<dynamic> createBookingRepo(
    String userName,
    String phoneNumber,
    String email,
    String type,
    String pickUp,
    int expectedEnd,
    int amount,
    String startDate,
    String startTime,
    String carName,
    String carType,
  ) async {
    var response;
    try {
      Map<String, dynamic> body = {
        "userName": userName,
        "phoneNumber": phoneNumber,
        "email": email,
        "type": type,
        "pickUp": pickUp,
        "expectedEnd": expectedEnd,
        "amount": amount,
        "startDate": startDate,
        "startTime": startTime,
        "carName": carName,
        "carType": carType,
      };

      print("create Booking Repo body :-- $body");
      response = await DioServices().postMethod(
        WebService().bookingBeforeAcceptApi,
        body,
        await DioServices().getAllHeaders(),
      );
      print("create Booking Repo response :-- $response");
    } catch (e) {
      print("create Booking Repo error :-- $e");
    }
    return response;
  }

  Future<dynamic> getSaveAddressRepo(String userNumber, userEmail, buildingName,
      nearBylandmark, area, pincode, city, state) async {
    var response;
    try {
      Map<String, dynamic> body = {
        "userNumber": userNumber,
        "userEmail": userEmail,
        "buildingName": buildingName,
        "nearBylandmark": nearBylandmark,
        "area": area,
        "pincode": pincode,
        "city": city,
        "state": state
      };
      print("get Save Address Repo body :-- $body");
      response = await DioServices().postMethod(WebService().getSaveAddressApi,
          body, await DioServices().getAllHeaders());
      print("get Save Address Repo response :-- $response");
    } catch (e) {
      print("get Save Address Repo error :-- $e");
    }
    return response;
  }

  /// Get vip offer repo
  Future<dynamic> getVipCardRepo(String type) async {
    var response;
    try {
      var url = "${WebService().getVipOffer}?type=$type";
      print("get Vip card Repo :-- $url");
      response = await DioServices()
          .getMethod(url, await DioServices().getAllHeaders());
      log("get Vip card Repo response :-- $response");
    } catch (e) {
      print("get Vip card Repo error :-- $e");
    }
    return response;
  }
}
