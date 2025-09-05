import 'package:drivio_sarthi/screens/authModule/SplashScreen.dart';
import 'package:get/get.dart';
import '../screens/authModule/SignUpScreen.dart';
import '../screens/authModule/loginScreen.dart';
import '../screens/authModule/onBoardingScreen.dart';
import '../screens/homeModule/HomeScreen.dart';
import '../screens/homeModule/ProfileScreen.dart';

class RouteHelper{
  static final RouteHelper _routeHelper = RouteHelper._internal();

  factory RouteHelper(){
    return _routeHelper;
  }
  RouteHelper._internal();

  String splashScreen = "/SplashScreen";
  String loginScreen = "/LoginScreen";
  String signUpScreen = "/SignUpScreen";
  String homeScreen = "/HomeScreen";
  String profileScreen = "/ProfileScreen";
  String onBoardingScreen = "/OnBoardingScreen";

  String getSplashScreen() => splashScreen;
  String getLoginScreen() => loginScreen;
  String getSignUpScreen() => signUpScreen;
  String getHomeScreen() => homeScreen;
  String getProfileScreen() => profileScreen;
  String getOnBoardingScreen() => onBoardingScreen;

  List<GetPage> get pageList => [
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: loginScreen, page: () => LoginScreen()),
    GetPage(name: signUpScreen, page: () => SignUpScreen()),
    GetPage(name: homeScreen, page: () => HomeScreen()),
    GetPage(name: profileScreen, page: () => ProfileScreen()),
    GetPage(name: onBoardingScreen, page: () => OnBoardingScreen()),
  ];

}