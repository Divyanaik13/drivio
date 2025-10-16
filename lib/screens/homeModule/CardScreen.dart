import 'package:drivio_sarthi/network/RazorePayApi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/RazorPayController.dart';

class CardScreen extends StatefulWidget {
  const CardScreen({super.key});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  final paymentCtrl = Get.put(RazorPayController(PaymentApi()));


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: Colors.black),
        title: Text(
          "Payment",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Saved Card Option
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.credit_card, color: Colors.redAccent),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Visa ending in 1234",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        SizedBox(height: 4),
                        Text("Expiry 06/2026",
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right),
                ],
              ),
            ),
            SizedBox(height: 20),

            Text(
              "Choose another method",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),
            ),
            SizedBox(height: 10),

            // UPI Option
            _optionTile(
              icon: Icons.account_balance_wallet_outlined,
              title: "UPI APPS",
              subtitle: "Amazon pay, Phone pe, G Pay",
            ),
            SizedBox(height: 10),

            // Driver info
            _optionTile(
              icon: Icons.person,
              title: "Assigned Driver",
              subtitle:
              "Shyam singh (29 year male)\n⭐ 4.3 (120 rides)\n5 yrs experience - Verified license",
            ),
            SizedBox(height: 10),

            // Arrival info
            _optionTile(
              icon: Icons.access_time,
              title: "Arrives",
              subtitle: "Arrives 10 min",
            ),

            Spacer(),

            // Payment Button
            Center(
              child: Column(
                children: [
                  Text(
                    "Complete your payment",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8),
                  
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      paymentCtrl.startPayment(
                        amountInRupees: 1,
                        platform: 'android',
                        name: 'Kanita Verma',
                        phone: '07489704225',
                        email: '',
                      );
                     // Get.toNamed(RouteHelper().getOrderPlacedSuccessScreen());
                    },
                    child: Text(
                      "Pay · ₹100",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),

             /* ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () {
                  paymentCtrl.startPayment(
                    amountInRupees: cartController.totalAmount.value,  // dynamic amount
                    platform: Platform.isAndroid ? 'android' : 'ios',  // platform detect
                    name: userController.userName.value,               // user name from profile
                    phone: userController.userPhone.value,             // user phone
                    email: userController.userEmail.value,             // user email
                  );
                },
                child: Obx(() => Text(
                  "Pay · ₹${cartController.totalAmount.value}",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                )),
              );*/

              ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _optionTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
