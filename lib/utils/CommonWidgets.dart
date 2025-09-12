import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sizer/sizer.dart';

import 'CommonFunctions.dart';
import 'ConstColors.dart';

class CommonWidgets {
  static Widget customTextField({
    required TextEditingController controller,
    TextInputType? keyboardType,
    required String hintText,
    IconData? prefixIcon,
    Widget? prefixImage,
    String? Function(String?)? validator,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
    Function(String?)? onChanged,
    IconData? suffixIcon,
    Widget? suffixImage,
  }) {
    return TextFormField(
      controller: controller,
      cursorColor: Colors.black,
      cursorHeight: 22,
      keyboardType: keyboardType ?? TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.black),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.black),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.black),
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: Icon(prefixIcon, size: 24, color: Colors.black),
              )
            : (prefixImage != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 20, right: 10),
                    child: prefixImage,
                  )
                : null),
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Icon(suffixIcon, size: 24, color: Colors.green),
              )
            : (suffixImage != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 20, right: 10),
                    child: suffixImage,
                  )
                : null),
      ),
      validator: validator,
      inputFormatters: inputFormatters ??
          (maxLength != null
              ? [LengthLimitingTextInputFormatter(maxLength)]
              : null),
      onChanged: onChanged,
    );
  }

  static Widget customButton({
    required BuildContext context,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFFFF2800)),
          color: const Color(0xFFFF2800),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  static void showLoader(BuildContext context) {
    EasyLoading.show(dismissOnTap: false);
  }

  static void hideLoader(BuildContext context) {
    EasyLoading.dismiss();
  }

  Widget customBorderButtonWithColorBorder(
      String text, void Function() onTap, Color color) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          // Gradient border
          Container(
            width: double.infinity,
            height: 6.h,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          // Inner white container
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: ConstColors().whiteColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(text,
                    style: CommonFunctions()
                        .commonTextStyle(FontWeight.w600, 16, colors: color)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Custom Screens Button
  Widget customBorderButton(String text, void Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ConstColors().whiteColor,
          border: Border.all(color: ConstColors().themeColor, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight:  FontWeight.w600,fontSize: 18,
              color: ConstColors().themeColor),
        ),
      ),
    );
  }
}
