import 'package:dio/dio.dart';
import 'package:drivio_sarthi/models/vip_card_model.dart';
import 'package:drivio_sarthi/network/ApiService.dart';
import 'package:drivio_sarthi/network/WebService.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class VipCardRepository {
  final DioServices _apiService = Get.find<DioServices>();
  final String _vipCardApi = WebService().vipCardApi;

  Future<VipCardModel> getVipCardData() async {
    try {
      final response = await _apiService.getMethod(
          _vipCardApi, await _apiService.getAllHeaders());
      if (response.statusCode == 200) {
        return VipCardModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to load vip card data with response code ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print("Dio error: ${e.response!.data}");
        throw Exception(
            "Api error: ${e.response!.data['message'] ?? " An unknown error occured"}");
      } else {
        print("Dio network error occured ${e.message}");
        throw Exception("Network error");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("An unknown error occured");
    }
  }
}
