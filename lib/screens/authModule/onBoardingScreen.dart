import 'package:drivio_sarthi/utils/AssetsImages.dart';
import 'package:drivio_sarthi/utils/ConstColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sizer/sizer.dart';

import '../../utils/CommonFunctions.dart';
import '../../utils/RouteHelper.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _pages = [
    {
      "title1": "Your Car,",
      "title2": " Our Driver",
      "subtitle1": "Get a professional driver anytime, anywhere—",
      "subtitle2": "\ntap, ride, relax.",
      "image": AssetsImages().driverImage1,
    },
    {
      "title1": "Safe & Verified ",
      "title2": "Drivers",
      "subtitle1": "Every driver is verified for a safe, reliable,",
      "subtitle2": "\nstress-free ride.",
      "image": AssetsImages().driverImage2,
    },
    {
      "title1": "Ride",
      "title2": " Your Way",
      "subtitle1": "Pay only for what you use—hourly, daily per trip.",
      "subtitle2": "\nSimple, flexible, transparent pricing.",
      "image": AssetsImages().driverImage3,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 4.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Get.toNamed(RouteHelper().getLoginScreen());
                  },
                  child: Text(
                    "Skip",
                    style: CommonFunctions().commonTextStyle(
                        FontWeight.w500, 15,
                        colors: ConstColors().themeColor),
                  ),
                ),
                Row(
                  children: List.generate(
                    _pages.length,
                    (index) => Container(
                      margin: const EdgeInsets.all(4),
                      width: _currentIndex == index ? 12 : 8,
                      height: _currentIndex == index ? 12 : 8,
                      decoration: BoxDecoration(
                        color: _currentIndex == index
                            ? Colors.red
                            : Colors.grey.shade400,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: ConstColors().themeColor),
                      color: ConstColors().themeColor),
                  child: InkWell(
                      onTap: () {
                        if (_currentIndex == _pages.length - 1) {
                        } else {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeIn,
                          );
                        }
                      },
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 20,
                      )),
                )
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (_currentIndex == _pages.length - 1) {
                } else {
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeIn,
                  );
                }
              },
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 15.h),
                        RichText(
                          text: TextSpan(
                            text: _pages[index]["title1"],
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                            children: [
                              TextSpan(
                                text: _pages[index]["title2"],
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                    color: ConstColors().themeColor),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text.rich(
                          TextSpan(
                            text: _pages[index]["subtitle1"],
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey),
                            children: [
                              TextSpan(
                                text: _pages[index]["subtitle2"],
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: ConstColors().themeColor),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Image.asset(
                          _pages[index]["image"]!,
                          height: 50.h,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
