import 'package:drivio_sarthi/utils/CommonFunctions.dart';
import 'package:drivio_sarthi/utils/CommonWidgets.dart';
import 'package:drivio_sarthi/utils/RouteHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sizer/sizer.dart';

class OneWayTripScreen extends StatefulWidget {
  const OneWayTripScreen({super.key});

  @override
  State<OneWayTripScreen> createState() => _OneWayTripScreenState();
}

class _OneWayTripScreenState extends State<OneWayTripScreen> {
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: (){
              Get.back();
            },
            child: Icon(Icons.arrow_back, color: Colors.black)),
        title: Text(
          "One-way trip ↻",
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left side icons
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    SizedBox(height: 15),
                    Icon(Icons.circle, color: Colors.red, size: 18),
                    SizedBox(height: 18),
                    Icon(Icons.more_vert_rounded, color: Colors.black, size: 18),
                    SizedBox(height: 18),
                    Icon(Icons.circle, color: Colors.green, size: 18),
                  ],
                ),
                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    children: [
                      CommonWidgets.customTextField(
                        controller: fromController,
                        keyboardType: TextInputType.name,
                        hintText: "From where?",
                        prefixIcon: Icons.location_on_outlined,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                          LengthLimitingTextInputFormatter(100),
                        ],
                      ),
                      const SizedBox(height: 12),
                      CommonWidgets.customTextField(
                        controller: toController,
                        keyboardType: TextInputType.name,
                        hintText: "To?",
                        prefixIcon: Icons.location_on_outlined,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                          LengthLimitingTextInputFormatter(100),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              "Search history",
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: (){
                Get.toNamed(RouteHelper().oneWayTripDetailScreen);
              },
              child: Text(
                "Phoenix - Shopping mall",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            Text(
              "837 Howard St, india , CA 94103, Indore",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
