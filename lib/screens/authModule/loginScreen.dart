import 'package:another_telephony/telephony.dart';
import 'package:drivio_sarthi/controllers/AuthController.dart';
import 'package:drivio_sarthi/utils/ConstColors.dart';
import 'package:drivio_sarthi/utils/RouteHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../utils/CommonFunctions.dart';
import '../../utils/CommonWidgets.dart';
import '../../utils/ConstStrings.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
  final _formKey = GlobalKey<FormState>();
  var authController = Get.find<AuthController>();
  TextEditingController numberController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  final telephony = Telephony.instance;
  var textReceived = "".obs;

  String? otpCode;
  var _numberError = "".obs;

  @override
  void initState() {
    super.initState();
    if(Get.arguments != null){
      numberController.text = Get.arguments;
    }
    numberController.addListener(() {
      if (_numberError.value != "") {
          _numberError.value = "";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 100.h - 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 100.h * 0.06),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: ConstStrings().drivTxt,
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700, color: Colors.black),
                      children: [
                        TextSpan(
                          text: ConstStrings().ioTxt,
                          style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700, color: ConstColors().themeColor),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 100.h * 0.06),
                 Text(ConstStrings().logInTxt, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: CommonWidgets.customTextField(
                    controller: numberController,
                    keyboardType: TextInputType.number,
                    hintText: ConstStrings().enterMobileNumberTxt,
                    prefixIcon: Icons.person_outline,
                    validator: validateMobile,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30, top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 60,
                child: CommonWidgets.customButton(
                  context: context,
                  text: ConstStrings().continueTxt,
                  onTap: (){
                    if (_formKey.currentState!.validate()) {
                      authController
                          .loginApi(
                          numberController.text.trim(),
                        ).then((response) {
                        final data = response.data;
                        print("login value :-- $data");
                        if (data is Map && data['success'] == 1) {
                          CommonFunctions().showOtpBottomSheet(
                            numberController.text.trim(),
                            "login", (otp){
                              authController.verifyOtpApi(numberController.text.trim(), otp, "login");
                          }, () {
                              print("Resend OTP clicked");
                        },
                          );
                        }
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(ConstStrings().dontHaveAnAccountTxt),
                  InkWell(
                    onTap: (){
                      Get.toNamed(RouteHelper().getSignUpScreen());
                    },
                    child: Text(
                      ConstStrings().signUpTxt,
                      style: TextStyle(
                          color: ConstColors().themeColor,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? validateMobile(String? value) {
    if (value == null || value.isEmpty) return "Please enter your number";
    final pattern = r'^[6-9]\d{9}$';
    if (!RegExp(pattern).hasMatch(value.trim())) return "Please enter a valid mobile number";
    if (_numberError.value != "") return _numberError.value;
    return null;
  }

 @override
  void dispose() {
    super.dispose();
  }
}
