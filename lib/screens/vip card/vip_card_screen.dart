import 'package:carousel_slider/carousel_slider.dart';
import 'package:drivio_sarthi/controllers/vip_card_controller.dart';
import 'package:drivio_sarthi/screens/widgets/wg_carousel_slider.dart';
import 'package:drivio_sarthi/screens/widgets/wg_lefticon_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sizer/sizer.dart';

import '../../utils/CommonWidgets.dart';
import '../homeModule/messages_screen.dart';

class VipCardScreen extends StatelessWidget {
  VipCardScreen({super.key});
  final List<String> crouselImages = [
    "assets/images/vipcardd.png",
    "assets/images/poster_min.png",
  ];
// final VipCardController vipCardController = Get.put(VipCardController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            WgLefticonText(
              icon: Icons.arrow_back,
              text: "Doc vip card",
              onTap: () {
                Get.to(MessagesScreen());
              },
              isBold: true,
            ),
            ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  "assets/images/vipcardd.png",
                  height: 20.h,
                  width: 200.w,
                  fit: BoxFit.fill,
                )),
            SizedBox(
              height: 2.h,
            ),
            Obx(()
                {
                  // if(vipCardController.isLoading.value){
                  //   return Center(child: CircularProgressIndicator());
                  // }
             return  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: "Unlimited",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: " Comfort,",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      TextSpan(
                        text: " Just ₹ 599/month.",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      )
                    ]));
                }),
            Text(
              "Enjoy priority rides, zero extra fees, and exclusive savings every month. Upgrade to VIP and make every journey smoother, safer, and smarter",
              style: TextStyle(color: Colors.grey, fontSize: 14.sp),
              textAlign: TextAlign.center,
            ),
            WgTextRightTextButton(
              prfixText: 'Ongoing Benefits',
              suffixText: 'See all',
              onTap: () {},
              pFontSize: 14.sp,
              sFontSize: 14.sp,
              isBold: true,
            ),
            Obx(() {

              // if(vipCardController.isLoading.value){
              //   return SizedBox.shrink();
              // }

             if(crouselImages.isEmpty){
               return Center(child: Text("no image is available"));

             }


             return WgCarouselSlider(crouselImages: crouselImages, onTap: (index) {
                if (index == 0) {
                  print("user tap ${crouselImages[index]}");
                }
                else if (index == 1) {
                  print("user Tap on second image${crouselImages[index]}");
                }
              },);
            }),
          ],
        ),
      )),
    );
  }
}
