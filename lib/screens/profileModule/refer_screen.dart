import 'package:drivio_sarthi/utils/AssetsImages.dart';
import 'package:drivio_sarthi/utils/CommonWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../utils/LocalStorage.dart';

class ReferAndEarnPage extends StatefulWidget {
  const ReferAndEarnPage({super.key});

  @override
  State<ReferAndEarnPage> createState() => _ReferAndEarnPageState();
}

class _ReferAndEarnPageState extends State<ReferAndEarnPage> {
  final LocalStorage ls = LocalStorage();

  String _referralCode = "";
  bool openFaq = true;

  @override
  void initState() {
    super.initState();
    _referralCode = ls.getStringValue(ls.referral);
  }

  void _copy() async {
    if (_referralCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No referral code found")),
      );
      return;
    }
    await Clipboard.setData(ClipboardData(text: _referralCode));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Referral code $_referralCode copied")),
    );
  }

  void _invite() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Share your code: $_referralCode")),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFFFF3B17);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidgets.appBarWidget("Refer & Earn"),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                AssetsImages().referCodeImage,
                height: 50.h,
                fit: BoxFit.contain,
              ),
              Text(
                "Your Referral Code",
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                ),
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      /*_referralCode.isEmpty ? "------" :*/ _referralCode,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                        color: primary,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: _copy,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.copy_rounded, size: 30),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // FAQ section
              InkWell(
                onTap: () => setState(() => openFaq = !openFaq),
                child: Row(
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Q1. ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 15.sp),
                            ),
                            TextSpan(
                              text: "How does the service work?",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.grey.shade900,
                                fontSize: 15.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Icon(
                      openFaq
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 200),
                crossFadeState: openFaq
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "When you share your referral code with friends and they sign up using it, "
                        "your friend gets ₹100 on their first ride. Once their ride is completed, "
                        "you also receive ₹100 in your wallet. It’s that simple — share, ride, and earn!",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      height: 1.5,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
                secondChild: const SizedBox.shrink(),
              ),
              SizedBox(height: 12.h), // Space before bottom button
            ],
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _invite,
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
              elevation: 0,
            ),
            child: Text(
              "Invite Friends",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

