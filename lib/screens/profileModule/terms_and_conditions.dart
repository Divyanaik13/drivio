import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../controllers/terms_and_conditon_controller.dart';
import '../../utils/widgets/wg_lefticon_text.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    final TermsAndConditionController termsAndConditionController =
        Get.put(TermsAndConditionController());
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          WgLefticonText(
            icon: Icons.arrow_back,
            text: "Terms and Conditon",
            onTap: () {
              Get.back();
            },
            isBold: true,
          ),
          Obx(() {
            if (termsAndConditionController.isLoading.value) {
              return Center(child: const CircularProgressIndicator());
            }
            if (termsAndConditionController.hasError.value) {
              return Center(child: Text("Error"));
            }
            if (termsAndConditionController.termsData.value == null) {
              return Center(child: Text("No Data"));
            }
            return Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      termsAndConditionController.termsData.value!.content,
                      style: TextStyle(fontSize: 14.sp)),
                ),
              ),
            );
          })
        ],
      )),
    );
  }
}
