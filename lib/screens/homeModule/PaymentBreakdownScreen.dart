import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../controllers/PaymentCalController.dart';

class PaymentBreakdownScreen extends StatefulWidget {
  const PaymentBreakdownScreen({super.key});

  @override
  State<PaymentBreakdownScreen> createState() => _PaymentBreakdownScreenState();
}

class _PaymentBreakdownScreenState extends State<PaymentBreakdownScreen> {
  var paymentController = Get.find<PaymentController>();

/*  @override
  void initState() {
    super.initState();
    final args = Get.arguments ?? {};

    // Extract each one
    final String type = args["type"] ?? "";
    final String startDate = args["startDate"] ?? "";
    final String endDate = args["endDate"] ?? "";
    final String startTime = args["startTime"] ?? "";
    final String endTime = args["endTime"] ?? "";
    final String extra = args["extra"] ?? "no";
    final String discount = args["discount"] ?? "";
    final dynamic expectedEnd = args["expectedEnd"];

    paymentController.paymentCalApi(
        "", "", "", startTime, endTime, expectedEnd,type, extra, "");

  }*/

  @override
  void initState() {
    super.initState();
    final args = Get.arguments ?? {};

    // Extract values safely
    final String type = (args["type"] ?? "").toString();
    final String startDate = (args["startDate"] ?? "").toString();
    final String endDate = (args["endDate"] ?? "").toString();
    final String startTime = (args["startTime"] ?? "").toString();
    final String endTime = (args["endTime"] ?? "").toString();
    final String extra = (args["extra"] ?? "no").toString();
    final String discount = (args["discount"] ?? "").toString();
    final dynamic expectedEnd = args["expectedEnd"] ?? "";

    print("🔹 PaymentBreakdownScreen init with args:");
    print("type: $type");
    print("startDate: $startDate, endDate: $endDate");
    print("startTime: $startTime, endTime: $endTime");
    print("expectedEnd: $expectedEnd, extra: $extra, discount: $discount");

    // ✅ Conditional API call
    if (type.toLowerCase() == "hourly") {
      // HOURLY API BODY
      final hourlyBody = {
        "type": "hourly",
        "startTime": startTime,
        "endTime": endTime,
        "expectedEnd": expectedEnd,
        "extra": extra,
      };
      print("📦 HOURLY payload → $hourlyBody");

      paymentController.paymentCalApi(
        "", // bookingId if not used
        "", // startDate not needed for hourly
        "", // endDate not needed for hourly
        startTime,
        endTime,
        expectedEnd.toString(),
        "hourly",
        extra,
        discount,
      );
    } else {
      // OUTSTATION API BODY
      final outstationBody = {
        "type": "outstation",
        "startDate": startDate,
        "endDate": endDate,
        "startTime": startTime,
        "endTime": endTime,
        "extra": extra,
        "discount": discount,
      };
      print("📦 OUTSTATION payload → $outstationBody");

      paymentController.paymentCalApi(
        "", // bookingId if not used
        startDate,
        endDate,
        startTime,
        endTime,
        expectedEnd.toString(),
        "outStation",
        extra,
        discount,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "Payment Breakdown",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 17.sp,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
            onPressed: () => Get.back(),
          ),
        ),
        body: Obx(() {
          if (paymentController.totalAmount.value == 0) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = paymentController.paymentCalModel.value!.data;

          print("paymentCalModel data ${jsonEncode(data)}");
          print("paymentCalModel data ${data?.ratePerHour}");

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pricing Details for a ${data?.plannedHours} hr Trip",
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),

                _buildPriceRow("Rate per Hour", "₹${data?.ratePerHour}"),
                _buildPriceRow("Planned Minutes", "${data?.plannedMinutes} min"),
                _buildPriceRow("Platform Fees", "₹${data?.platformFees}"),
                _buildPriceRow("Night Charges", "₹${data?.nightCharges}"),
                _buildPriceRow("Extra Charges", "₹${data?.extraCharges}"),
                _buildPriceRow("Subtotal", "₹${data?.subTotal}"),
                Divider(thickness: 1, height: 20),
                _buildPriceRow("Total Amount", "₹${data?.totalAmount}",
                    isBold: true),
              ],
            ),
          );
        }),
      );
    });
  }

  Widget _buildPriceRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.7.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15.sp,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15.sp,
              color: Colors.black,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
