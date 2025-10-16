import 'package:drivio_sarthi/utils/BindingClass.dart';
import 'package:drivio_sarthi/utils/ConstColors.dart';
import 'package:drivio_sarthi/utils/RouteHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  configLoading();
  runApp(const MyApp());
}

void configLoading() {
  EasyLoading.instance
    ..maskType = EasyLoadingMaskType.black
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom // use custom style
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..backgroundColor = Colors.white // white background
    ..indicatorColor = Colors.red // red loader
    ..textColor = Colors.black
    ..maskColor = Colors.black.withOpacity(0.3)
    ..userInteractions = false
    ..dismissOnTap = false;
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
   return Sizer(builder: (context, orientation, screenType){
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Drivio-O-Call',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Poppins',
          colorScheme: ColorScheme.fromSeed(seedColor: ConstColors().themeColor),
        ),
        initialRoute: RouteHelper().getSplashScreen(),
        getPages: RouteHelper().pageList,
        initialBinding: BindingClass(),
        builder: (context, child) {
          final mq = MediaQuery.of(context);
          double scale = mq.textScaler.scale(1.0);
          if (scale < 0.85) scale = 0.85;
          if (scale > 1.15) scale = 1.15;
          return MediaQuery(
            data: mq.copyWith(textScaler: TextScaler.linear(scale)),
            child: EasyLoading.init()(context, child),
          );
        },
      );
    });
  }
}