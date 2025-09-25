import 'package:another_telephony/telephony.dart';
import 'package:drivio_sarthi/utils/AssetsImages.dart';
import 'package:drivio_sarthi/utils/ConstColors.dart';
import 'package:drivio_sarthi/utils/RouteHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/AuthController.dart';
import '../../utils/CommonFunctions.dart';
import '../../utils/CommonWidgets.dart';
import '../../utils/ConstStrings.dart';
import '../../utils/Debounce.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  var authController = Get.find<AuthController>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController referralController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final telephony = Telephony.instance;
  String textReceived = "";
  var _numberError = "".obs;
  String? otpCode;
  String? code;
  Debouncer debounce = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      mobileController.text = Get.arguments;
    } else {}
    mobileController.addListener(() {
      if (_numberError.value != "") {
        _numberError.value = "";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: screenHeight - 40),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.06),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: ConstStrings().drivTxt,
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: ConstStrings().ioTxt,
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                              color: ConstColors().themeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.06),
                  Text(
                    ConstStrings().signUpTxt,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        CommonWidgets.customTextField(
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          hintText: ConstStrings().enterYourFullNameTxt,
                          prefixIcon: Icons.person_outline,
                          validator: validateName,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z\s]')),
                            LengthLimitingTextInputFormatter(25),
                          ],
                        ),
                        const SizedBox(height: 20),
                        CommonWidgets.customTextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          hintText: ConstStrings().yourEmailIdTxt,
                          prefixIcon: Icons.mail_outline,
                          validator: validateEmail,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50),
                          ],
                        ),
                        const SizedBox(height: 20),
                        CommonWidgets.customTextField(
                          controller: mobileController,
                          keyboardType: TextInputType.number,
                          hintText: ConstStrings().enterMobileNumberTxt,
                          prefixIcon: Icons.phone_android,
                          validator: validateMobile,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Obx(() {
                          return CommonWidgets.customTextField(
                            controller: referralController,
                            keyboardType: TextInputType.text,
                            hintText: ConstStrings().referralCodeTxt,
                            prefixImage: Image.asset(
                                AssetsImages().referralCodeIcon,
                                height: 22,
                                width: 22),
                            validator: authController.validateReferral,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^[a-zA-Z0-9]*$')),
                              LengthLimitingTextInputFormatter(6),
                            ],
                            onChanged: (event) {
                              debounce.run(() {
                                authController.referralCodeApi(
                                    referralController.text, _formKey);
                              });
                            },
                            suffixIcon: authController.isReferral.value
                                ? Icons.check_circle
                                : null,
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        ConstStrings().wellUseYourPhoneNumberTxt,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black38,
                            fontWeight: FontWeight.w400,
                            fontSize: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: ConstStrings().bySigningInYouAgreeToYourTxt,
                        style: TextStyle(fontSize: 15, color: Colors.black),
                        children: [
                          TextSpan(
                            text: ConstStrings().termsAndConditionsTxt,
                            style: TextStyle(color: ConstColors().themeColor),
                          ),
                          TextSpan(text: ConstStrings().andTxt),
                          TextSpan(
                            text: ConstStrings().privacyPolicyTxt,
                            style: TextStyle(color: ConstColors().themeColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, bottom: 30, top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Continue Button
              SizedBox(
                height: 60,
                child: CommonWidgets.customButton(
                  context: context,
                  text: ConstStrings().continueTxt,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      authController
                          .signUpApi(
                              nameController.text.trim(),
                              mobileController.text.trim(),
                              emailController.text.trim(),
                              referralController.text.trim())
                          .then((response) {
                        final data = response.data;
                        print("sign up value :-- $data");
                        if (data is Map && data['success'] == 1) {
                          CommonFunctions().showOtpBottomSheet(
                            mobileController.text.trim(),
                            (otp) {
                              print("OTP submitted: $otp");
                              // if (authController
                              //     .otpTextController.text.isEmpty) {
                              //   CommonFunctions().alertDialog(
                              //       "Alert", "Please enter OTP", "Ok", () {
                              //     Get.back();
                              //   });
                              // } else if (authController
                              //         .otpTextController.text.length <
                              //     4) {
                              //   CommonFunctions().alertDialog(
                              //       "Alert", "Please enter correct OTP", "Ok",
                              //       () {
                              //     Get.back();
                              //   });
                              // } else {
                              //   authController.verifyOtpApi(
                              //       mobileController.text.trim(),
                              //       authController.otpTextController.text
                              //           .trim(),
                              //       "signup");
                              // }
                              authController.verifyOtpApi(
                                  mobileController.text.trim(),
                                  otp,
                                  "signup");
                            },
                            () {
                              // resend otp tab
                            },
                          );
                        }
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 15),

              /// Already have account?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(ConstStrings().alreadyHaveAnAccountTxt),
                  InkWell(
                    onTap: () {
                      Get.toNamed(RouteHelper().getLoginScreen());
                    },
                    child: Text(
                      ConstStrings().loginTxt,
                      style: TextStyle(
                        color: ConstColors().themeColor,
                        fontWeight: FontWeight.w700,
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

  /// validations
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your name";
    }
    if (value.length < 3) {
      return "Name must be at least 3 characters long";
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your email";
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return "Please enter a valid email";
    }
    return null;
  }

  String? validateMobile(String? value) {
    if (value == null || value.isEmpty) return "Please enter your number";
    final pattern = r'^[6-9]\d{9}$';
    if (!RegExp(pattern).hasMatch(value.trim()))
      return "Please enter a valid mobile number";
    if (_numberError.value != "") return _numberError.value;
    return null;
  }

/*  String? validateReferral(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter referral code";
    }
    return null;
  }*/
}
