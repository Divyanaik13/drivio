import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sizer/sizer.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({super.key});

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Terms and Conditions", style: TextStyle(fontSize: 17.sp,fontWeight: FontWeight.w500),),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Terms & Conditions - Driver On Call (DOC)""Effective Date: 01-01-2025\nLast Updated: 01-02-2025\n\nWelcome to Driver On Call (DOC) – a driver-on-demand application (“App”) designed to connect users with professional drivers as per their needs. By downloading, accessing, or using this App, you (“User”, “You”) agree to comply with and be bound by the following Terms & Conditions. Please read them carefully before using our services.\n\n1. Acceptance of Terms\nBy using DOC, you agree to these Terms & Conditions, our Privacy Policy, and any additional guidelines we may publish. If you do not agree, you must discontinue using the App.\n\n2. Services Provided\nDriver On Call (DOC) provides on-demand drivers for:\n• Elderly individuals needing assistance.\n• Weddings, events, or special occasions.\n• Users without a valid driver’s license.\n• Outstation and long-distance travel.\n• Any other approved use as permitted by the company.\nThe App only facilitates the connection between drivers and users. The Company does not own, employ, or directly operate vehicles.\n\n3. User Eligibility\n• Users must be at least 18 years old to book a driver.\n• Users must provide accurate personal and vehicle information when requesting services.\n• Users are responsible for ensuring their vehicle is in safe and lawful condition.\n\n4. Booking & Payment\n• All bookings must be made through the DOC App.\n• Charges may vary depending on location, time, distance, and type of service.\n• Payment must be made through the available in-app payment methods or as instructed.\n• Cancellations may incur charges as per the cancellation policy shown during booking.\n\n5. Driver Responsibilities\n• Drivers are independent service providers.\n• Drivers must follow traffic laws, ensure passenger safety, and act professionally.\n• The Company is not liable for the personal conduct of drivers.\n\n6. User Responsibilities\n• Users must treat drivers respectfully.\n• Users must not engage drivers for illegal activities.\n• Users are responsible for their belongings during the ride.\n• Users must not misuse the App or attempt fraudulent bookings.\n\n7. Liability & Disclaimer\nThe Company acts as a facilitator between users and drivers.\nThe Company is not responsible for:\n• Any accidents, damages, or delays caused during service.\n• Loss or theft of personal belongings.\n• Misconduct of drivers or users.\nServices are provided on an “as is” basis without any warranties.\n\n8. Insurance\n• Users must ensure their vehicles are properly insured before engaging a driver.\n• The Company does not provide vehicle or passenger insurance.\n\n9. Termination\n• The Company reserves the right to suspend or terminate any user account for violation of these Terms.\n• Users may discontinue using the App at any time by uninstalling it.\n\n10. Privacy & Data Protection\n• We collect and process personal data in accordance with our Privacy Policy.\n• By using the App, you consent to such collection and processing.\n\n11. Governing Law & Jurisdiction\n• These Terms shall be governed by the laws of India (or your applicable jurisdiction).\n• Any disputes shall be subject to the exclusive jurisdiction of the courts in [Insert City/State].\n\n12. Updates to Terms\n• The Company may update these Terms at any time.\n• Continued use of the App after updates means you accept the revised Terms.\n\nContact Us\nFor any queries or complaints, contact us at:\nDriver On Call (DOC)\nEmail: support@driveroncall.com\nPhone: +91-9999999999"),
            ],
          ),
        ),
      ),
    );
  }
}
