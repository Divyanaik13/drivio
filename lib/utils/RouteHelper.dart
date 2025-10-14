import 'package:drivio_sarthi/screens/authModule/SplashScreen.dart';
import 'package:get/get.dart';
import '../screens/authModule/PrivacyPolicy.dart';
import '../screens/authModule/SignUpScreen.dart';
import '../screens/authModule/loginScreen.dart';
import '../screens/authModule/onBoardingScreen.dart';
import '../screens/homeModule/AddNewCarScreen.dart';
import '../screens/homeModule/CardScreen.dart';
import '../screens/homeModule/HomeScreen.dart';
import '../screens/homeModule/OneWayTrip.dart';
import '../screens/homeModule/OneWayTripDetailScreen.dart';
import '../screens/homeModule/OrderPlacedSuccessScreen.dart';
import '../screens/homeModule/PaymentBreakdownScreen.dart';
import '../screens/homeModule/SelectLocationScreen.dart';
import '../screens/homeModule/my_coins_screen.dart';
import '../screens/homeModule/notification_screen.dart';
import '../screens/profileModule/FAQScreen.dart';
import '../screens/profileModule/MyCarScreen.dart';
import '../screens/profileModule/ProfileScreen.dart';
import '../screens/profileModule/SavedAddressScreen.dart';
import '../screens/profileModule/refer_screen.dart';
import '../screens/profileModule/terms_and_conditions.dart';
import '../screens/profileModule/vip_card_screen.dart';

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
  String oneWayTripScreen = "/OneWayTripScreen";
  String oneWayTripDetailScreen = "/OneWayTripDetailScreen";
  String cardScreen = "/CardScreen";
  String orderPlacedSuccessScreen = "/OrderPlacedSuccessScreen";
  String paymentBreakdownScreen = "/PaymentBreakdownScreen";
  String vipCardScreen = "/VipCardScreen";
  String addNewCarScreen = "/AddNewCarScreen";
  String privacyPolicyScreen = "/PrivacyPolicyScreen";
  String notificationScreen = "/NotificationScreen";
  String termsAndConditions = "/TermsAndConditions";
  String myCoinsScreen = "/MyCoinsScreen";
  String savedAddressScreen = "/SavedAddressScreen";
  String myCarScreen = "/MyCarScreen";
  String selectLocationScreen = "/SelectLocationScreen";
  String referAndEarnPage = "/ReferAndEarnPage";
  String faqScreen = "/FaqScreen";

  String getSplashScreen() => splashScreen;
  String getLoginScreen() => loginScreen;
  String getSignUpScreen() => signUpScreen;
  String getHomeScreen() => homeScreen;
  String getProfileScreen() => profileScreen;
  String getOnBoardingScreen() => onBoardingScreen;
  String getOneWayTripScreen() => oneWayTripScreen;
  String getOneWayTripDetailScreen() => oneWayTripDetailScreen;
  String getCardScreen() => cardScreen;
  String getOrderPlacedSuccessScreen() => orderPlacedSuccessScreen;
  String getPaymentBreakdownScreen() => paymentBreakdownScreen;
  String getVipCardScreen() => vipCardScreen;
  String getAddNewCarScreen() => addNewCarScreen;
  String getPrivacyPolicyScreen() => privacyPolicyScreen;
  String getNotificationScreen() => notificationScreen;
  String getTermsAndConditions() => termsAndConditions;
  String getMyCoinsScreen() => myCoinsScreen;
  String getSavedAddressScreen() => savedAddressScreen;
  String getMyCarScreen() => myCarScreen;
  String getSelectLocationScreen() => selectLocationScreen;
  String getReferAndEarnPage() => referAndEarnPage;
  String getFaqScreen() => faqScreen;

  List<GetPage> get pageList => [
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: loginScreen, page: () => LoginScreen()),
    GetPage(name: signUpScreen, page: () => SignUpScreen()),
    GetPage(name: homeScreen, page: () => HomeScreen()),
    GetPage(name: profileScreen, page: () => ProfileScreen()),
    GetPage(name: onBoardingScreen, page: () => OnBoardingScreen()),
    GetPage(name: onBoardingScreen, page: () => OnBoardingScreen()),
    GetPage(name: oneWayTripScreen, page: () => OneWayTripScreen()),
    GetPage(name: oneWayTripDetailScreen, page: () => OneWayTripDetailScreen()),
    GetPage(name: cardScreen, page: () => CardScreen()),
    GetPage(name: orderPlacedSuccessScreen, page: () => OrderPlacedSuccessScreen()),
    GetPage(name: paymentBreakdownScreen, page: () => PaymentBreakdownScreen()),
    GetPage(name: vipCardScreen, page: () => VipCardScreen()),
    GetPage(name: addNewCarScreen, page: () => AddNewCarScreen()),
    GetPage(name: privacyPolicyScreen, page: () => PrivacyPolicyScreen()),
    GetPage(name: notificationScreen, page: () => NotificationScreen()),
    GetPage(name: termsAndConditions, page: () => TermsAndConditions()),
    GetPage(name: myCoinsScreen, page: () => MyCoinsScreen()),
    GetPage(name: savedAddressScreen, page: () => SavedAddressScreen()),
    GetPage(name: myCarScreen, page: () => MyCarScreen()),
    GetPage(name: selectLocationScreen, page: () => SelectLocationScreen()),
    GetPage(name: referAndEarnPage, page: () => ReferAndEarnPage()),
    GetPage(name: faqScreen, page: () => FaqScreen()),
  ];

}