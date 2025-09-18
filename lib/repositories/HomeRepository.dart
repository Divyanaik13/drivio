import 'dart:io';

import 'package:drivio_sarthi/network/ApiService.dart';
import 'package:drivio_sarthi/network/WebService.dart';

class HomeRepo {
  Future<dynamic> searchHistoryListRepo(String phoneNumber, int page, limit) async {
    var response;

    try {
      var url =
          "${WebService().getSearchHistoryApi}?user_phoneNumber=$phoneNumber&page=$page&limit=$limit";
      print("Search History url :-- $url");
      response = await DioServices()
          .getMethod(url, await DioServices().getAllHeaders());
      print("Search History repo response :-- $response");
    } catch (e) {
      print("Search History repo error :-- $e");
    }
    return response;
  }

  Future<dynamic> createSearchHistoryRepo(String phoneNumber, latitude, longitude,address,dateTime) async {
    var response;
    try {
      Map<String, dynamic> body = {
        "user_phoneNumber": phoneNumber,
        "lateLog": "$latitude,$longitude",
        "address": address,
        "device": Platform.isAndroid?"android":"ios",
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
}
