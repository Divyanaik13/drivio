import 'package:another_telephony/telephony.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../repositories/AuthRepository.dart';
import '../utils/CommonFunctions.dart';
import '../utils/LocalStorage.dart';
import '../utils/RouteHelper.dart';

class AuthController extends GetxController{
  final AuthRepo _authRepo;

  AuthController(this._authRepo);

  LocalStorage ls = LocalStorage();
  var isReferral = false.obs;
  var referralErrorMessage = RxnString();

  /// Sign-up api function
  Future<dynamic> signUpApi(String fullname, String mobileNumber, email, referral) async{
    CommonFunctions().showLoader();
    var response;
    try{
      response = await _authRepo.signUpRepo(fullname, mobileNumber, email, referral);
      print("sign up response :-- $response");
      CommonFunctions().hideLoader();
      if(response.data["success"] == 0){
        CommonFunctions().alertDialog("Alert", response.data["message"], "Ok", (){
          Get.offAllNamed(RouteHelper().getLoginScreen(),arguments: mobileNumber);
        });
      }
    }catch(e){
      print("Error sign up api :-- $e");
      CommonFunctions().hideLoader();
    }
    return response;
  }

  ///verify otp api function
  Future<dynamic> verifyOtpApi(String mobileNumber, String otp, type) async{
    CommonFunctions().showLoader();
    var response;
    try{
      response = await _authRepo.verifyOtpRepo(mobileNumber, otp, type);
      print("verify otp response :-- $response");
      print("verify otp :-- $otp");
      CommonFunctions().hideLoader();
      if (response.statusCode == 200) {
        print("verify otp api success");
        var data = response.data["data"];
        print("data :-- $data");
        print("verify token :-- ${response.data["token"]}");
        var authToken = response.data["token"].toString()??"";
        var userId = data["id"].toString()??"";
        var fullName = data["fullname"].toString()??"";
        var email = data["email"].toString()??"";
        var mobileNumber = data["mobileNumber"].toString()??"";
        var referral = data["referral"].toString()??"";
        var myCoins = data["myCoins"].toString()??"";

        print("authToken :-- $authToken");
        print("userId :-- $userId");
        print("fullName :-- $fullName");
        print("email :-- $email");
        print("mobileNumber :-- $mobileNumber");
        print("referral :-- $referral");

        LocalStorage().setStringValue(ls.authToken, authToken);
        LocalStorage().setStringValue(ls.userId, userId);
        LocalStorage().setStringValue(ls.fullName, fullName);
        LocalStorage().setStringValue(ls.email, email);
        LocalStorage().setStringValue(ls.mobileNumber, mobileNumber);
        LocalStorage().setStringValue(ls.referral, referral);
        LocalStorage().setStringValue(ls.myCoins, myCoins);

        print("verify otp data save :-- ${ LocalStorage().getStringValue(ls.authToken)}");
        Get.offAllNamed(RouteHelper().getHomeScreen());
      }
    }catch(e){
      print("Error verify otp api :-- $e");
      CommonFunctions().hideLoader();
    }
    return response;
  }

  /// login api function
  Future<dynamic> loginApi(String mobileNumber) async{
    CommonFunctions().showLoader();
    var response;
    try{
      response = await _authRepo.loginRepo(mobileNumber);
      CommonFunctions().hideLoader();
      if(response.data["success"] == 0){
        CommonFunctions().alertDialog("Alert", response.data["message"], "Ok", (){
          Get.offAllNamed(RouteHelper().getSignUpScreen(),arguments: mobileNumber);
        });
      }
    }catch(e){
      print("Error login api :-- $e");
      CommonFunctions().hideLoader();
    }
    return response;
  }

  Future<dynamic> logoutApi() async{
    CommonFunctions().showLoader();
    var response;
    try{
      response = await _authRepo.logoutRepo();
      print("logout api response :-- $response");
      CommonFunctions().hideLoader();
      if (response != null && response.data['success'] == 1) {
        print("Logout success");

        LocalStorage().clearLocalStorage();

       await Get.offAllNamed(RouteHelper().getLoginScreen());
      }
    }catch(e){
      print("logout error :-- $e");
      CommonFunctions().hideLoader();
    }
    return response;
  }


  /// Referral code
  Future<dynamic> referralCodeApi(String referralCode,GlobalKey<FormState> formKey)async{
  //  CommonFunctions().showLoader();
    var response;
    try{
      response = await _authRepo.referralCodeRepo(referralCode);
      print("referral Code Api response :-- $response");
    //  CommonFunctions().hideLoader();
      if(response.data["success"] == 1){
        isReferral.value = true;
        referralErrorMessage.value = null;
      }else{
        isReferral.value = false;
        referralErrorMessage.value = "You have entered incorrect referral code";
      }
      formKey.currentState?.validate();
    }catch(e){
      print("referral Code Api error :-- $e");
      referralErrorMessage.value = "Something went wrong";
    //  CommonFunctions().hideLoader();
      formKey.currentState?.validate();
    }
  }

  String? validateReferral(String? value) {
    return referralErrorMessage.value; // error comes from API
  }

  /// otp autofill functionality
  final Telephony _telephony = Telephony.instance;

  var isListeningForCode = false.obs;
  final TextEditingController otpTextController = TextEditingController();
  final RxString otpCode = ''.obs;

  Future<void> startOtpListener() async {
    if (isListeningForCode.value) return;

    final granted = await (_telephony.requestSmsPermissions ?? false);
    if (granted == false) {
      debugPrint("SMS permission not granted");
      return;
    }

    _telephony.listenIncomingSms(
      listenInBackground: false,
      onNewMessage: (SmsMessage message) {
        final body = message.body ?? '';
        final match = RegExp(r'\b(\d{4,6})\b').firstMatch(body);
        if (match != null) {
          final code = match.group(1)!;
          otpCode.value = code;
          otpTextController.text = code;
          debugPrint("Auto OTP filled: $code");
        }
      },
    );

    isListeningForCode.value = true;
  }

  Future<void> stopOtpListener() async {
    isListeningForCode.value = false;
  }

  @override
  void onClose() {
    otpTextController.dispose();
    super.onClose();
  }
}
