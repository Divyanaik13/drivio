import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sizer/sizer.dart';

import '../utils/widgets/wg_lefticon_text.dart';

class PaymentBreakdownScreen extends StatelessWidget {
  PaymentBreakdownScreen({super.key});

  final List<Map<String, String>> paymentList = [
    {'title': 'Price', 'amount': '₹279.00'},
    {'title': 'Drive secure fee', 'amount': '₹15'},
    {'title': 'Taxes & fees', 'amount': '₹30.00'},
    {'title': 'Subtotal', 'amount': '₹324'},
    {'title': 'Total amount', 'amount': '₹324'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              WgLefticonText(
                icon: Icons.arrow_back,
                text: "Payement Breakdown",
                onTap: () {
                  Get.back();
                },
                isBold: true,
              ),
              Text(
                "Pricing Details for a 60 Min Trip",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: paymentList.length,
                    itemBuilder: (context, index) {
                      final payment = paymentList[index];
                      return WgTextRightTextButton(
                        prfixText: '${payment['title']}',
                        suffixText: '${payment['amount']}',
                        onTap: () {},
                        pFontSize: 14.sp,
                        sFontSize: 14.sp,
                        suffixColor: Colors.black,
                        prfixColor: Colors.black54,
                        isBold: true,
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
