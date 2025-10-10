import 'dart:async';
import 'package:another_telephony/telephony.dart';
import 'package:flutter/material.dart';
import 'package:drivio_sarthi/utils/LocalStorage.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../utils/AssetsImages.dart';
import '../../utils/RouteHelper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Telephony telephony = Telephony.instance;

  LocalStorage ls = LocalStorage();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
   // requestSmsPermission();
  }

 Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 3));

    final storage = LocalStorage();

    bool firstLaunch = storage.getBoolValue(storage.isFirstLaunch);
    String token = storage.getStringValue(storage.authToken);
    print("firstLaunch ! $firstLaunch");
    if (!firstLaunch) {
      Get.offAllNamed(RouteHelper().getOnBoardingScreen());
    } else if (token.isNotEmpty) {
      // already logged in
      Get.offAllNamed(RouteHelper().getHomeScreen());
    } else {
      // logged out
      Get.offAllNamed(RouteHelper().getLoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset(AssetsImages().docLogoImage, height: 70.h, width: 100.w,),
      ),
    );
  }
}
