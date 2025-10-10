import 'package:drivio_sarthi/model/SearchHistoryListModel.dart';
import 'package:drivio_sarthi/utils/CommonFunctions.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../repositories/HomeRepository.dart';

class HomeController extends GetxController {
  final HomeRepo _homeRepo;

  HomeController(this._homeRepo);

  var searchHistoryList = <SearchHistoryList>[].obs;
  var searchHistoryListModel = Rxn<SearchHistoryListModel>();
  var lastSearch = "".obs;
  var bookingID = 0.obs;

  ///Search History List Repo Function
  Future<void> searchHistoryListApi(String phoneNumber, int page, limit) async {
    CommonFunctions().showLoader();
    searchHistoryList.clear();
    var response;
    try {
      response =
          await _homeRepo.searchHistoryListRepo(phoneNumber, page, limit);
      CommonFunctions().hideLoader();
      print("searchHistoryListApi response :-- $response");
      searchHistoryListModel.value =
          SearchHistoryListModel.fromJson(response.data);
      searchHistoryList.value = searchHistoryListModel.value!.data;
      lastSearch.value = searchHistoryList[0].address;
      print("searchHistoryList.value :-- $searchHistoryList");
      print("lastSearch.value :-- ${lastSearch.value}");
    } catch (e) {
      CommonFunctions().hideLoader();
      print("searchHistoryListApi error :-- $e");
    }
    return response;
  }

  ///Create History Api Function
  Future<void> createSearchHistoryApi(
      String phoneNumber, latitude, longitude, address, dateTime) async {
    CommonFunctions().showLoader();
    var response;
    try {
      response = await _homeRepo.createSearchHistoryRepo(
          phoneNumber, latitude, longitude, address, dateTime);
      CommonFunctions().hideLoader();
      print("createSearchHistoryApi response :-- $response");
    } catch (e) {
      CommonFunctions().hideLoader();
      print("createSearchHistoryApi error :-- $e");
    }
    return response;
  }

  ///Create booking Api Function
  Future<int?> createBookingApi(
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
    CommonFunctions().showLoader();
    var response;
    try {
      response = await _homeRepo.createBookingRepo(
        userName,
        phoneNumber,
        email,
        type,
        pickUp,
        expectedEnd,
        amount,
        startDate,
        startTime,
        carName,
        carType,
      );

      CommonFunctions().hideLoader();
      print("create Booking Api response :-- $response");
      var data = response.data;
      print("create Booking Api data :-- $data");

      if (data["status"] == 1 ||
          data["message"] == "Booking created successfully") {
        var bookingId = data["data"]["id"];
        print(" Booking ID: $bookingId");
        return bookingId;
      } else {
        CommonFunctions().alertDialog(
          "Booking Failed",
          data["message"] ?? "Please try again later.",
          "OK",
              () => Get.back(),
        );
        return null;
      }
    } catch (e) {
      CommonFunctions().hideLoader();
      print("create Booking Api error :-- $e");
      return null;
    }
  }

  ///get save address Api Function
  Future<void> getSaveAddressApi(
      String userNumber, userEmail, buildingName, nearBylandmark, area, pincode, city, state) async {
    CommonFunctions().showLoader();
    var response;
    try {
      response = await _homeRepo.getSaveAddressRepo(
           userNumber, userEmail, buildingName, nearBylandmark, area, pincode, city, state);
      CommonFunctions().hideLoader();
      print("get Save Address Api response :-- $response");
    } catch (e) {
      CommonFunctions().hideLoader();
      print("get Save Address Api error :-- $e");
    }
    return response;
  }


}
