import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'ConstColors.dart';

class UploadImageDialog {
  static Future<dynamic> show(
    BuildContext context,
    Function() onCamera,
    Function() onGalley,
  ) {
    return showModalBottomSheet(
        backgroundColor: Colors.black.withOpacity(0.01),
        context: context,
        builder: (BuildContext cntx) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Column(
                children: [
                  GestureDetector(
                    onTap: onCamera,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      width: 100.w,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                        ),
                        color: ConstColors().whiteColor,
                      ),
                      child: Text("Camera",
                          textAlign: TextAlign.center,
                          style: /*CommonFunctions().textStyle(FontWeight.w600,
                              15.sp, colors:  ConstColors().blackColor)*/
                              TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.sp,
                                  color: Colors.black)),
                    ),
                  ),
                  GestureDetector(
                    onTap: onGalley,
                    child: Container(
                      width: 100.w,
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        border: const Border(
                          top: BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                        color: ConstColors().whiteColor,
                      ),
                      child: Text("Gallery",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15.sp,
                              color: Colors.black)),
                    ),
                  ),
                ],
              ),
              Container(
                color: Colors.black.withOpacity(0.01),
              ),
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ConstColors().themeColor,
                  ),
                  child: Center(
                    child: Text("Cancel",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15.sp,
                            color: Colors.white)),
                  ),
                ),
              )
            ],
          );
        });
  }
}
