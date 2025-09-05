import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../utils/CommonWidgets.dart';

class CommonOtpBottomSheet {
  static void show({
    required String mobileNumber,
    required TextEditingController otpController,
    required String? otpCode,
    required VoidCallback startListening,
    required VoidCallback stopListening,
    required VoidCallback onVerify,
    required Future<void> Function(String mobile) onResendOtp,
  }) {
    // Start listening for SMS autofill
    startListening();

    Get.bottomSheet(
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 50,
          bottom: MediaQuery.of(Get.context!).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Verify your mobile number",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 6),
            Text("OTP sent to +91 $mobileNumber"),
            const SizedBox(height: 35),

            /// OTP Input
            PinFieldAutoFill(
              controller: otpController,
              codeLength: 4,
              currentCode: otpCode,
              onCodeChanged: (code) {
                if (code != null && code.length == 4) {
                  otpController.text = code;
                  onVerify();
                }
              },
              decoration: UnderlineDecoration(
                textStyle: const TextStyle(fontSize: 20, color: Colors.black),
                colorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.3)),
              ),
            ),
            const SizedBox(height: 20),

            /// Resend OTP
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Didn't get the code? "),
                InkWell(
                  onTap: () async {
                    if (mobileNumber.isNotEmpty) {
                      await onResendOtp(mobileNumber);
                      Get.snackbar(
                        "Success",
                        "OTP resent successfully",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                  child: const Text(
                    "Resend It",
                    style: TextStyle(
                      color: Color(0xFFFF2800),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),

            /// Continue Button
            CommonWidgets.customButton(
              context: Get.context!,
              text: "Continue",
              onTap: onVerify,
            ),
          ],
        ),
      ),
    ).whenComplete(() {
      // Stop listening when sheet closed
      stopListening();
    });
  }
}
