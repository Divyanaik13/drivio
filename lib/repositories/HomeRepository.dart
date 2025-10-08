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

/*  Future<dynamic> createBookingRepo(
      String userName,
      phoneNumber,
      email,
      type,
      pickUp,
      expectedEnd,
      int amount,
      startDate,
      startTime,
      carName,
      carType,
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
       *//* "userName": "Divya Arya",
        "phoneNumber": "6263934024",
        "email": "divya123@gmail.com",
        "type": "hourly",
        "pickUp": "JIT",
        "expectedEnd": "2",
        "amount": 300,
        "startDate": "2025-09-22",
        "startTime": "12:02:10",
        "carName": "auto",
        "carType": "Manual"*//*
      };

      print("create Booking Repo body :-- $body");
      response = await DioServices().postMethod(
          WebService().bookingBeforeAcceptApi,
          body,
          await DioServices().getAllHeaders());
      print("create Booking Repo response :-- $response");
    } catch (e) {
      print("create Booking Repo error :-- $e");
    }
    return response;
  }*/

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


}
