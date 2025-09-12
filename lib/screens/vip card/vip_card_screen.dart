import 'package:drivio_sarthi/screens/widgets/wg_lefticon_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../utils/CommonWidgets.dart';

class VipCardScreen extends StatelessWidget {
  const VipCardScreen({super.key});

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
              onTap: () {},
              isBold: true,
            ),
            Image.asset("assets/images/vipcardd.png"),
            RichText(
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
                text: " Just ₹299/month.",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              )
            ])),
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Image.asset("assets/images/vipcrowsel.png"),
                  Image.asset("assets/images/vipcrowsel.png"),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
