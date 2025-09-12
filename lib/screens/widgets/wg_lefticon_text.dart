import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class WgLefticonText extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final double? fontSize;
  final double? iconSize;
  final bool? isBold;
  const WgLefticonText(
      {super.key,
      required this.icon,
      required this.text,
      required this.onTap,
      this.fontSize,
      this.iconSize,
      this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: onTap,
            icon: Icon(
              icon,
              size: iconSize,
            )),
        Text(
          text,
          style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold! ? FontWeight.bold : FontWeight.normal),
        ),
        SizedBox(
          width: 20.w,
        )
      ],
    );
  }
}

class WgTextRightTextButton extends StatelessWidget {
  final String prfixText;
  final double? pFontSize;
  final String suffixText;
  final double? sFontSize;
  final bool? isBold;
  final VoidCallback onTap;
  const WgTextRightTextButton(
      {super.key,
      required this.prfixText,
      required this.suffixText,
      required this.onTap,
      this.pFontSize,
      this.sFontSize,
      this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          prfixText,
          style: TextStyle(
              fontSize: pFontSize,
              fontWeight: isBold! ? FontWeight.bold : FontWeight.normal),
        ),
        TextButton(
          onPressed: onTap,
          style: ButtonStyle(
            overlayColor: WidgetStateProperty.all(Colors.transparent),
          ),

          child: Text(suffixText,
              style: TextStyle(
                  fontSize: pFontSize,
                  color: Colors.red,
                  fontWeight: isBold! ? FontWeight.bold : FontWeight.normal)),
        )
      ],
    );
  }
}

