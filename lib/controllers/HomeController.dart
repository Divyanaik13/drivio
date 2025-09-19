import 'package:drivio_sarthi/model/SearchHistoryListModel.dart';
import 'package:drivio_sarthi/utils/CommonFunctions.dart';
import 'package:drivio_sarthi/utils/CommonWidgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../repositories/HomeRepository.dart';

class HomeController extends GetxController {

   final HomeRepo _homeRepo;

   HomeController(this._homeRepo);

   var searchHistoryList = <SearchHistoryList>[].obs;
   var searchHistoryListModel = Rxn<SearchHistoryListModel>();
   var lastSearch = "".obs;

   ///Search History List Repo Function
  Future<void> searchHistoryListApi(String phoneNumber, int page, limit) async{
    CommonFunctions().showLoader();
    searchHistoryList.clear();
    var response;
    try{
      response = await _homeRepo.searchHistoryListRepo(phoneNumber, page, limit);
      CommonFunctions().hideLoader();
      print("searchHistoryListApi response :-- $response");
      searchHistoryListModel.value = SearchHistoryListModel.fromJson(response.data);
      searchHistoryList.value = searchHistoryListModel.value!.data;
      lastSearch.value = searchHistoryList[0].address;
      print("searchHistoryList.value :-- $searchHistoryList");
      print("lastSearch.value :-- ${lastSearch.value}");
    }catch(e){
      CommonFunctions().hideLoader();
      print("searchHistoryListApi error :-- $e");
    }
    return response;
  }

   ///Create History Api Function
   Future<void> createSearchHistoryApi(String phoneNumber, latitude, longitude,address,dateTime) async{
     CommonFunctions().showLoader();
     var response;
     try{
       response = await _homeRepo.createSearchHistoryRepo(phoneNumber, latitude, longitude,address,dateTime);
       CommonFunctions().hideLoader();
       print("createSearchHistoryApi response :-- $response");
     }catch(e){
       CommonFunctions().hideLoader();
       print("createSearchHistoryApi error :-- $e");
     }
     return response;
   }
}