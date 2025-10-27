import '../network/ApiService.dart';
import '../network/WebService.dart';

class PaymentRepo {
  Future<dynamic> paymentCalRepo(
    String bookingId,
    String startDate,
    String endDate,
    String startTime,
    String endTime,
    String expectedEnd,
    String type,
    String extra,
    String discount,
  ) async {
    var response;
    try {
      var Url = "${WebService().getCalculatedPaymentApi}";
      //"/*?bookingId=$bookingId&startTime=$startTime&endTime=$endTime&expectedEnd=$expectedEnd&type=$type&extra=$extra*/";

      print("type $type");
      Map<String, dynamic> queryParameters = type == "outStation"
          ? {
              "type": type,
              "startDate": startDate,
              "endDate": endDate,
              "startTime": startTime,
              "endTime": endTime,
              "extra": extra,
              "discount": discount
            }
          : {
              "type": type,
              "startTime": startTime,
              "endTime": endTime,
              "expectedEnd": expectedEnd,
            };

      print("queryParameter :-- $queryParameters");
      response = await DioServices().getMethod1(
          Url, await DioServices().getAllHeaders(), queryParameters);
      print("Url payment cal Repo :-- $Url");
      print("payment cal Repo response :-- $response");
    } catch (e) {
      print("payment cal Repo error :-- $e");
    }
    return response;
  }
}
