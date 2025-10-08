import 'package:drivio_sarthi/screens/homeModule/messages_screen.dart';
import 'package:drivio_sarthi/screens/profileModule/vip_card_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/widgets/wg_lefticon_text.dart';
import '../../utils/widgets/wg_list_tile.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});
  final List<Map<String, String>> userNotifications = [
    {
      "headingText": "Ramesh • Swift Dzire (MP09 AB 1234)",
      "subHeading1": "Pickup: New Lig ",
      "subHeading2": "Drop: Phoenix Citadel Mall",
      "subHeading3": "ETA: 6 min",
      "subHeadingLeft": "Arriving",
      "imgUrl": "https://i.postimg.cc/cCsYDjvj/user-2.png",
    },
    {
      "headingText": "Harshit • Swift Dzire (MP09 AB 1234)",
      "subHeading1": "Pickup: New Lig ",
      "subHeading2": "Drop: Phoenix Citadel Mall",
      "subHeading3": "ETA: 6 min",
      "subHeadingLeft": "cancelled",
      "imgUrl": "https://i.postimg.cc/cCsYDjvj/user-2.png",
    }
  ];

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
            Expanded(
              child: ListView.builder(
                  itemCount: userNotifications.length,
                  itemBuilder: (context, index) {
                    final user = userNotifications[index];
                    final String userName = "${user["headingText"]}".split('•').first.trim();
                    return WgListTile(
                        height: 12,
                        width: 380,
                        headingText: "${user["headingText"]}",
                        subHeadingText1: "${user["subHeading1"]}",
                        subHeadingText2: "${user["subHeading2"]}",
                        subHeadingText3: "${user["subHeading3"]}",
                        subHeadingTextLeft: "${user["subHeadingLeft"]}",
                        headingColor: Colors.black,
                        subHeadingColor: Colors.grey,
                        onTap: () {Get.to(MessagesScreen(userName: userName,));},
                        imgUrl: "${user["imgUrl"]}");
                  }),
            )
          ],
        ),
      ),
    );
  }
}
