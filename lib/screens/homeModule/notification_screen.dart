import 'package:drivio_sarthi/screens/vip%20card/vip_card_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../widgets/wg_lefticon_text.dart';
import '../widgets/wg_list_tile.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            WgLefticonText(
              icon: Icons.arrow_back,
              text: "Notifications",
              onTap: () {
                Get.to(VipCardScreen());
              },
              isBold: true,
            ),
            WgListTile(height: 12, width: 380, headingText: "Ramesh • Swift Dzire (MP09 AB 1234)", subHeadingText1: "Pickup: New Lig ", subHeadingText2: "Drop: Phoenix Citadel Mall", subHeadingText3: "ETA: 6 min", subHeadingTextLeft: "Arriving", headingColor: Colors.black, subHeadingColor: Colors.grey, onTap: (){
              debugPrint("user clicked on list tile");
            }, networKImagePath: "https://i.postimg.cc/cCsYDjvj/user-2.png"),
            WgListTile(height: 12, width: 380, headingText: "Ramesh • Swift Dzire (MP09 AB 1234)", subHeadingText1: "Pickup: New Lig ", subHeadingText2: "Drop: Phoenix Citadel Mall", subHeadingText3: "ETA: 6 min", subHeadingTextLeft: "Arriving", headingColor: Colors.black, subHeadingColor: Colors.grey, onTap: (){
              debugPrint("user clicked on list tile");
            }, networKImagePath: "https://i.postimg.cc/cCsYDjvj/user-2.png")

          ],
        ),
      ),
    );
  }
}
