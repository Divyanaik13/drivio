import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../model/paymentCalculatedModel.dart';
import '../repositories/PaymentCalRepo.dart';
import '../utils/CommonFunctions.dart';

class PaymentController extends GetxController {
  final PaymentRepo _paymentRepo;

  PaymentController(this._paymentRepo);

  var paymentCalModel = Rxn<PaymentCalModel>();

  Future<dynamic> paymentCalApi(int bookingId, String startTime, String endTime,
      int expectedEnd, String type, String extra) async {
    CommonFunctions().showLoader();
    var response;
    try {
      response = await _paymentRepo.paymentCalRepo(
          bookingId, startTime, endTime, expectedEnd, type, extra);
      CommonFunctions().hideLoader();
      print("payment cal Api response :-- $response");
      if (response != null && response['status'] == true) {
        paymentCalModel.value = PaymentCalModel.fromJson(response);
        print("payment cal model :-- ${paymentCalModel.value}");
      }
    } catch (e) {
      CommonFunctions().hideLoader();
      print("payment cal Api error :-- $e");
    }
    return response;
  }
}
