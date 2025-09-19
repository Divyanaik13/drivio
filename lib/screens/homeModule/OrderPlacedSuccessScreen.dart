import 'package:drivio_sarthi/utils/RouteHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sizer/sizer.dart';

class OrderPlacedSuccessScreen extends StatefulWidget {
  const OrderPlacedSuccessScreen({super.key});

  @override
  State<OrderPlacedSuccessScreen> createState() => _OrderPlacedSuccessScreenState();
}

class _OrderPlacedSuccessScreenState extends State<OrderPlacedSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success Circle with Tick
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, color: Colors.white, size: 60),
              ),
              SizedBox(height: 24),

              // Success Text
              Text(
                "Success!",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 12),

              // Message
              Text(
                "Your payment was successful and your driver will be assigned shortly. Thank you for choosing our service.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 12),

              // Date & Time
              Text(
                "3-09-2025, 11:00 PM",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 40),

              // Track Driver Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () {
                  // Navigate to track driver screen
                },
                child: Text(
                  "Track Driver",
                  style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w700,),
                ),
              ),
              SizedBox(height: 16),

              // Back to Home
              TextButton(
                onPressed: () {
                  Get.toNamed(RouteHelper().getHomeScreen());
                },
                child: Text(
                  "Back to home",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
