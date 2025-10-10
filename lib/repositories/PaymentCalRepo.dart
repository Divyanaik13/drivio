import '../network/ApiService.dart';
import '../network/WebService.dart';

class PaymentRepo {
  Future<dynamic> paymentCalRepo(
    int bookingId,
    String startTime,
    String endTime,
    int expectedEnd,
    String type,
    String extra,
  ) async {
    var response;
    try {
      var Url =
          "${WebService().getCalculatedPaymentApi}?bookingId=$bookingId&startTime=$startTime&endTime=$endTime&expectedEnd=$expectedEnd&type=$type&extra=$extra";
      response = await DioServices()
          .getMethod(Url, await DioServices().getAllHeaders());
      print("Url payment cal Repo :-- $Url");
      print("payment cal Repo response :-- $response");
    } catch (e) {
      print("payment cal Repo error :-- $e");
    }
    return response;
  }
}
