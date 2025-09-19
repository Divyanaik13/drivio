import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class WgListTile extends StatelessWidget {

  final double height;
  final double width;
  final String headingText;
  final String subHeadingText1;
  final String subHeadingText2;
  final String subHeadingText3;
  final String subHeadingTextLeft;
  final Color headingColor;
  final Color subHeadingColor;
  final VoidCallback onTap;
  final String networKImagePath;



  const WgListTile({super.key, required this.height, required this.width, required this.headingText, required this.subHeadingText1, required this.subHeadingText2, required this.subHeadingText3, required this.subHeadingTextLeft, required this.headingColor, required this.subHeadingColor, required this.onTap, required this.networKImagePath});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.grey.shade200,
      borderRadius: BorderRadius.all(Radius.circular(20)),

      child: Container(
        height: height.h,
        width: width.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage("https://i.postimg.cc/cCsYDjvj/user-2.png"),
              radius: 35,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(headingText),
                Text(subHeadingText1,style: TextStyle(color: Colors.grey),),
                Text(subHeadingText2,style: TextStyle(color: Colors.grey),),
                Row(
                  children: [
                    Text(subHeadingText3,style: TextStyle(color: Colors.grey),),
                    SizedBox(width: 40.w,),
                    Text(subHeadingTextLeft,style: TextStyle(color: Colors.red),),
                  ],
                ),
              ],
            ),
            SizedBox()
          ],
        ),

      ),
    );
  }
}
