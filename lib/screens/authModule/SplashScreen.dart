import 'dart:async';
import 'package:another_telephony/telephony.dart';
import 'package:flutter/material.dart';
import 'package:drivio_sarthi/screens/homeModule/HomeScreen.dart';
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

/*  Future<bool> requestSmsPermission() async {
    final granted = await telephony.requestSmsPermissions ?? false;
    return granted;
  }*/

/*  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 3));

    final storage = LocalStorage();
    bool firstLaunch = storage.getBoolValue(storage.isFirstLaunch);
    String authToken = storage.getStringValue(storage.authToken);

    if (authToken.value != "" && authToken.value.isNotEmpty) {
      Get.offAllNamed(RouteHelper().getHomeScreen());
    } else {
      Get.offAllNamed(RouteHelper().getOnBoardingScreen());
    }
  }*/
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
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 8.h,
              width: 50.w,
              padding: EdgeInsets.only(right: 30.w),
              child: Image.asset(AssetsImages().splashIcon, height: 50),
            ),
            Image.asset(AssetsImages().drivioIcon, height: 50),
          ],
        ),
      ),
    );
  }
}
