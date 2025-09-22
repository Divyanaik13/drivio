import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../widgets/wg_button.dart';
import '../widgets/wg_lefticon_text.dart';

class ReferScreen extends StatelessWidget {
  ReferScreen({super.key});
  final String referCode = "ZXCV54";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              WgLefticonText(
                icon: Icons.arrow_back,
                text: "Refer and Earn",
                onTap: () {
                  Get.back();
                },
                isBold: true,
              ),
              Image.asset("assets/images/refermin.png"),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Your Referal Code",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    referCode,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 20.sp),
                  ),
                  IconButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: referCode));
                        Get.snackbar("Success",
                            " referral code ${referCode} Copied to clipboard");
                      },
                      icon: Icon(Icons.copy))
                ],
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: "Q1. How does the service work?\n",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
                TextSpan(
                    text:
                        "When you share your referral code with friends and they sign up using it, your friend gets ₹100 on their first ride. Once their ride is completed, you also receive ₹100 in your wallet. It’s that simple – share, ride, and earn!",
                    style: TextStyle(color: Colors.black)),
              ])),
              SizedBox(height: 20.h),
              WgButton(
                text: "Invite Friends",
                onTap: () {

                  SharePlus.instance.share(
                      ShareParams(text: 'check out my website https://example.com')
                  );
                },
                height: 4,
                width: 400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
