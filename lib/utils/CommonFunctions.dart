import 'package:drivio_sarthi/utils/AssetsImages.dart';
import 'package:drivio_sarthi/utils/ConstColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../controllers/AuthController.dart';
import 'CommonWidgets.dart';
import 'ConstStrings.dart';

class CommonFunctions {
  static final CommonFunctions _commonFunctions = CommonFunctions._internal();

  factory CommonFunctions() {
    return _commonFunctions;
  }

  CommonFunctions._internal();

  var isListeningForCode = false.obs;
  var appSignature = "".obs;
  var otpCode = "".obs;
  DateTime? selectedDate;
  DateTime? selectedTime;


  final TextEditingController otpController = TextEditingController();
  TextEditingController dateTimeController = TextEditingController();

  Future successDialog(String text, buttonTxt, Function() buttonTap) {
    return Get.defaultDialog(
      title: '',
      titlePadding: EdgeInsets.zero,
      barrierDismissible: false,
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      content: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 7.h,
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                decoration: BoxDecoration(
                  color: ConstColors().themeColor,
                ),
                child: Center(
                  child: Text(
                    ConstStrings().successTxt,
                    style: commonTextStyle(
                      FontWeight.w600,
                      20.sp,
                      colors: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(
                    left: 40, right: 40, bottom: 10, top: 30),
                child: Text(
                  text.tr,
                  textAlign: TextAlign.center,
                  style: CommonFunctions().commonTextStyle(
                    FontWeight.w600,
                    17.sp,
                    colors: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: CommonWidgets().customBorderButtonWithColorBorder(
                    buttonTxt, buttonTap, ConstColors().themeColor),
              ),
            ],
          ),
        ),
      ),
    );
  }


  TextStyle? commonTextStyle(FontWeight fontWeight,
      double fontSize,
      {Color? colors,
        TextDecoration? decoration,
        Color? decorationColor}) {
    return TextStyle(
        decoration: decoration,
        decorationColor: decorationColor,
        color: colors,
        fontFamily: "Outfit",
        fontWeight: fontWeight,
        fontSize: fontSize);
  }

  Future alertDialog(String title, text, buttonTxt, void Function() buttonTap,
      {bool isAlert = false}) {
    return Get.defaultDialog(
      title: '',
      titlePadding: EdgeInsets.zero,
      barrierDismissible: false,
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      content: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: ConstColors().whiteColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 7.h,
                width: double.infinity,
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                decoration: BoxDecoration(
                 color: ConstColors().themeColor
                ),
                child: isAlert
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title.tr,
                      style: CommonFunctions().commonTextStyle(
                        FontWeight.w600,
                        18.sp,
                        colors: ConstColors().whiteColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.cancel),
                      iconSize: 3.5.h,
                      padding: EdgeInsets.zero,
                      color: ConstColors().whiteColor,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                )
                    : Center(
                    child: Text(
                    title.tr,
                    style: CommonFunctions().commonTextStyle(
                      FontWeight.w600,
                      18.sp,
                      colors: ConstColors().whiteColor,
                    ),
                  ),
                ),
              ),
              Container(
                color: ConstColors().whiteColor,
                padding: const EdgeInsets.only(
                    left: 40, right: 40, bottom: 10, top: 30),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: CommonFunctions().commonTextStyle(
                    FontWeight.w600,
                    17.sp,
                    colors: ConstColors().blackColor,
                  ),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: CommonWidgets().customBorderButtonWithColorBorder(buttonTxt, buttonTap, ConstColors().themeColor)
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showLoader() {
    EasyLoading.show(dismissOnTap: false);
  }

  void hideLoader() {
    EasyLoading.dismiss();
  }
  /// OTP Bottom Sheet
  Future<void> showOtpBottomSheet(String mobileNumber,
      Function(String otp) onOtpSubmit,
      VoidCallback onResendTap,) async {
     final authController = Get.find<AuthController>();
     await authController.startOtpListener();

    await Get.bottomSheet(
      isScrollControlled: true,
      ignoreSafeArea: false,
      Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 50,
          bottom: MediaQuery.of(Get.context!).viewInsets.bottom + 20,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Verify your mobile number",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 6),
            Text("OTP sent to +91 $mobileNumber"),
            const SizedBox(height: 35),

            Obx(() => PinFieldAutoFill(
              controller: authController.otpTextController,
              codeLength: 4, // match your backend
              currentCode: authController.otpCode.value,
              onCodeChanged: (code) {
                if (code != null && code.length == 4) {
                  authController.otpCode.value = code;
                  authController.otpTextController.text = code;
                }
              })),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Didn't get the code? "),
                InkWell(
                  onTap: onResendTap,
                  child: const Text(
                    "Resend It",
                    style: TextStyle(
                        color: Color(0xFFFF2800),
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 50),

            CommonWidgets.customButton(
              context: Get.context!,
              text: "Continue",
              onTap: () => onOtpSubmit(authController.otpTextController.text),
            ),
          ],
        ),
      ),
    );
     await authController.stopOtpListener();
  }

  Future<DateTime?> dateTimePicker1() async {
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                  brightness: Brightness.light,
                  primary: ConstColors().themeColor ?? Color(0xFFFF4300)),
              datePickerTheme: DatePickerThemeData(
                headerBackgroundColor:
                ConstColors().themeColor ?? Color(0xFFFF4300),
                headerForegroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero),
              )),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: Get.context!,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                brightness: Brightness.light,
                primary: ConstColors().themeColor ?? const Color(0xFFFF4300),
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              timePickerTheme: TimePickerThemeData(
                dialHandColor: ConstColors().themeColor ?? const Color(0xFFFF4300),
                dialBackgroundColor: Colors.grey.shade200,
                entryModeIconColor: ConstColors().themeColor ?? const Color(0xFFFF4300),
                helpTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        final selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        print("Selected DateTime: $selectedDateTime");
         // _myDateTime = selectedDateTime;
      }
    }

    //debugPrint("selected date is $_myDateTime");
    return null;
  }

  Future<DateTime?> dateTimePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              brightness: Brightness.light,
              primary: ConstColors().themeColor ?? const Color(0xFFFF4300),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: Get.context!,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                brightness: Brightness.light,
                primary: ConstColors().themeColor ?? const Color(0xFFFF4300),
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        return DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      }
    }

    return null; // if user cancels
  }

}