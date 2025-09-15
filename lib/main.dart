import 'package:drivio_sarthi/utils/BindingClass.dart';
import 'package:drivio_sarthi/utils/ConstColors.dart';
import 'package:drivio_sarthi/utils/RouteHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
    ..maskType = EasyLoadingMaskType
        .black // Prevents interaction with widgets underneath
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..maskColor = Colors.transparent
    ..backgroundColor = Colors.black
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
        title: 'Drivio/Sarthi',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Poppins',
          colorScheme: ColorScheme.fromSeed(seedColor: ConstColors().themeColor),
        ),
        initialRoute: RouteHelper().getHomeScreen(),
        getPages: RouteHelper().pageList,
        initialBinding: BindingClass(),
        builder: (context, child) {
          final mediaQuery =
          MediaQuery.of(context).copyWith(textScaleFactor: 1.0);
          return MediaQuery(
            data: mediaQuery,
            child: EasyLoading.init()(context, child),
          );
        },
      );
    });
  }
}