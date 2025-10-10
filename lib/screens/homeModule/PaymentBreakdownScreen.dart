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


  @override
  void initState() {
    paymentController.paymentCalApi(39,"2024-10-10 10:00", "2024-10-10 12:00", 2, "hourly", "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final double basePrice = args["basePrice"] ?? 0;
    final double gst = args["gst"] ?? 0;
    final double lateNightCharges = args["lateNightCharges"] ?? 0;
    final double platformFees = args["platformFees"] ?? 0;
    final double total = args["total"] ?? 0;
    final int hours = args["hours"] ?? 0;

    return Sizer(
      builder: (context, orientation, deviceType) {
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

          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pricing Details for a $hours hr Trip",
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),

                _buildPriceRow("Base Fare", "₹${basePrice.toStringAsFixed(2)}"),
                _buildPriceRow("GST (18%)", "₹${gst.toStringAsFixed(2)}"),
                if (lateNightCharges > 0)
                  _buildPriceRow("Late Night Charges", "₹${lateNightCharges.toStringAsFixed(2)}"),
                if (platformFees > 0)
                  _buildPriceRow("Platform Fees", "₹${platformFees.toStringAsFixed(2)}"),

                const Divider(height: 25, thickness: 1),
                _buildPriceRow("Total Amount", "₹${total.toStringAsFixed(2)}"),
              ],
            ),
          ),

          bottomNavigationBar: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.redAccent, size: 18),
                      SizedBox(width: 1.w),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          "View cancellation policy",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w500,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: continue
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 1.8.h),
                    ),
                    child: Text(
                      "Continue",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget _buildPriceRow(String title, String value) {
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
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

