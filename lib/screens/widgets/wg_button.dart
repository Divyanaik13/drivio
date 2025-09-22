import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class WgButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double? fontSize;
  final Color? color;
  final Color? textColor;
  final double? height;
  final double? width;

  const WgButton(
      {super.key,
      required this.text,
      required this.onTap,
      this.fontSize,
      this.color,
      this.textColor,
      this.height,
      this.width});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height?.h,
        width: width?.w,
        decoration: BoxDecoration(
          color: color ?? Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: Center(
            child: Text(text,
                style: TextStyle(
                    fontSize: fontSize,
                    color: textColor ?? Colors.white,
                    fontWeight: FontWeight.bold,

                    ))),
      ),
    );
  }
}
