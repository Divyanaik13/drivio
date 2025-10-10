import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/material.dart';

import '../network/RazorePayApi.dart';

class RazorPayController extends GetxController {
  final PaymentApi api;
  RazorPayController(this.api);

  late Razorpay razorpay;
  var loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _onExternalWallet);
  }

  @override
  void onClose() {
    razorpay.clear();
    super.onClose();
  }

  Future<void> startPayment({
    required int amountInRupees,
    required String platform,
    String? name,
    String? email,
    String? phone,
  }) async {
    loading.value = true;
    try {
      final order = await api.createOrder(
        amountInRupees: amountInRupees,
        platform: platform,
        name: name,
        email: email,
        phone: phone,
      );
      final keyId = await api.getKeyId();

      final options = {
        "key": keyId,
        "order_id": order["id"],
        "amount": order["amount"],       // in paise from Razorpay order
        "currency": order["currency"],
        "name": platform,
        "description": "Payment via $platform",
        "timeout": 300,
        "prefill": { "name": name, "email": email, "contact": phone },
        "notes": { "platform": platform, "from": "flutter_app" },
      };

      razorpay.open(options);
    } finally {
      loading.value = false;
    }
  }

  void _onSuccess(PaymentSuccessResponse r) async {
    try {
      final result = await api.verifyPayment(
        razorpayOrderId: r.orderId!,
        razorpayPaymentId: r.paymentId!,
        razorpaySignature: r.signature!,
        platform: "android",
      );
      Get.snackbar('Payment', (result['message'] ?? 'Verified ✅').toString(),
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Payment', 'Verify failed: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _onError(PaymentFailureResponse r) {
    Get.snackbar('Payment', 'Failed: ${r.code} ${r.message}',
        snackPosition: SnackPosition.BOTTOM);
  }

  void _onExternalWallet(ExternalWalletResponse r) {
    Get.snackbar('Wallet', 'External wallet: ${r.walletName}',
        snackPosition: SnackPosition.BOTTOM);
  }
}
