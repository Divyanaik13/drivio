/*
import 'package:another_telephony/telephony.dart';
import 'package:flutter/material.dart';
import 'package:drivio_sarthi/screens/authModule/loginScreen.dart';
import 'package:drivio_sarthi/screens/homeModule/HomeScreen.dart';
import 'package:drivio_sarthi/utils/LocalStorage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sizer/sizer.dart';

import '../../utils/AssetsImages.dart';
import '../../utils/RouteHelper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var authToken = LocalStorage().(LocalStorage().authToken);
  final Telephony telephony = Telephony.instance;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    requestSmsPermission();
  }

  Future<bool> requestSmsPermission() async {
    final granted = await telephony.requestSmsPermissions ?? false;
    return granted;
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 5));

    if (authToken != null && authToken.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      Get.offAllNamed(RouteHelper().getOnBoardingScreen());
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
                child: Image.asset(AssetsImages().splashIcon, height: 50,)),
            Image.asset(AssetsImages().drivioIcon, height: 60,),
          ],
        ),
      ),
    );
  }
}
*/
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
  String? authToken;
  final Telephony telephony = Telephony.instance;

  @override
  void initState() {
    super.initState();
    _initToken();
    requestSmsPermission();
  }

  Future<void> _initToken() async {
    authToken = await LocalStorage.getToken();
    _checkLoginStatus();
  }

  Future<bool> requestSmsPermission() async {
    final granted = await telephony.requestSmsPermissions ?? false;
    return granted;
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 3));

    if (authToken != null && authToken!.isNotEmpty) {
      Get.offAll(() => const HomeScreen());
    } else {
      Get.offAllNamed(RouteHelper().getOnBoardingScreen());
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
