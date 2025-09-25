
import 'package:drivio_sarthi/screens/homeModule/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
class TempScreen extends StatelessWidget {


  TempScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text("Temp Screen"),
                wgLeftIconText(
                    (){
                      Get.to(()=>HomeScreen());
                    },
                    Icons.arrow_back,
                    "Add"
                ),
              ],
            ),
          ),


        ),

      ),
    );
  }
}

Widget wgLeftIconText(void Function() callBack , IconData icon, String text){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
     IconButton(onPressed: callBack, icon: Icon(icon)),
      Text(text),
      SizedBox(),
    ],
  );
}