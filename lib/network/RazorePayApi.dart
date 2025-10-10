import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentApi {
  final String baseUrl;
  PaymentApi({this.baseUrl = 'https://pay.indew.co.in'});

  Future<Map<String, dynamic>> createOrder({
    required int amountInRupees,
    required String platform,
    String? name,
    String? email,
    String? phone,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/orders'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "amount": amountInRupees,
        "platform": platform,
        "name": name ?? "",
        "email": email ?? "",
        "phone": phone ?? "",
      }),
    );
    if (res.statusCode != 200) {
      throw Exception('Create order failed: ${res.statusCode} ${res.body}');
    }
    return jsonDecode(res.body);
  }

  Future<String> getKeyId() async {
    final res = await http.get(Uri.parse('$baseUrl/api/config'));
    if (res.statusCode != 200) {
      throw Exception('Key fetch failed: ${res.statusCode} ${res.body}');
    }
    return (jsonDecode(res.body)['key_id'] as String);
  }

  Future<Map<String, dynamic>> verifyPayment({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
    required String platform,
    String? name,
    String? email,
    String? phone,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/verify-payment'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "razorpay_order_id": razorpayOrderId,
        "razorpay_payment_id": razorpayPaymentId,
        "razorpay_signature": razorpaySignature,
        "platform": platform,
        "name": name ?? "",
        "email": email ?? "",
        "phone": phone ?? "",
      }),
    );

    if (res.statusCode != 200) {
      throw Exception('Verify failed: ${res.statusCode} ${res.body}');
    }
    return jsonDecode(res.body);
  }
}
