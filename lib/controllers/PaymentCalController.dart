import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../model/paymentCalculatedModel.dart';
import '../repositories/PaymentCalRepo.dart';
import '../utils/CommonFunctions.dart';

class PaymentController extends GetxController {
  final PaymentRepo _paymentRepo;

  PaymentController(this._paymentRepo);

  var paymentCalModel = Rxn<PaymentCalModel>();

  var totalAmount = 0.obs;
  var isLoading = false.obs;

  Future<dynamic> paymentCalApi(String bookingId,
      String startDate,
      String endDate,
      String startTime,
      String endTime,
      String expectedEnd,
      String type,
      String extra,
      String discount) async {
   // CommonFunctions().showLoader();
    var response;
    try {
      response = await _paymentRepo.paymentCalRepo(
         bookingId,
         startDate,
         endDate,
         startTime,
         endTime,
         expectedEnd,
         type,
         extra,
         discount);
      CommonFunctions().hideLoader();
      var responseData = response.data;
      print("payment cal Api response 1:-- ${response.data['success']}");
      print("payment cal Api response :-- ${jsonEncode(responseData)}");


      // CORRECT WAY TO ACCESS RESPONSE
      if (response != null && responseData['success'] == 1) {
        // First set the model
        paymentCalModel.value = PaymentCalModel.fromJson(responseData);
        print("payment cal model :-- ${jsonEncode(paymentCalModel.value)}");

        // Then extract totalAmount from data
        if (responseData['data'] != null && responseData['data']['totalAmount'] != null) {
          totalAmount.value = responseData['data']['totalAmount'];
          print("Total Amount Updated: ₹${totalAmount.value}");
        }
      }
    } catch (e) {
      CommonFunctions().hideLoader();
      print("payment cal Api error :-- $e");
      // Fallback on error
    }
    return response;
  }
}