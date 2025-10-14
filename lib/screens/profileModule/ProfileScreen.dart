import 'package:drivio_sarthi/utils/CommonFunctions.dart';
import 'package:drivio_sarthi/utils/ConstStrings.dart';
import 'package:drivio_sarthi/utils/RouteHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import '../../controllers/AuthController.dart';
import '../../controllers/profileController.dart';
import '../../utils/AssetsImages.dart';
import '../../utils/CommonWidgets.dart';
import '../../utils/ConstColors.dart';
import '../../utils/LocalStorage.dart';
import '../../utils/SelectImageDialoge.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  var authController = Get.find<AuthController>();
  var profileController = Get.find<ProfileController>();

  LocalStorage ls = LocalStorage();

  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  var isEditing = false.obs;
  var userId = "".obs;
  var isLoading = true.obs;
  var _numberError = "".obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  Future<void> _loadUserData() async {
    userId.value = ls.getStringValue(ls.userId);
    fullnameController.text = ls.getStringValue(ls.fullName);
    emailController.text = ls.getStringValue(ls.email);
    mobileNumberController.text = ls.getStringValue(ls.mobileNumber);
    print("userId.value :-- ${userId.value}");
    print("fullnameController.text :-- ${fullnameController.text}");
    print("emailController.text :-- ${emailController.text}");
    print("mobileNumberController.text :-- ${mobileNumberController.text}");

    String savedProfileImg = ls.getStringValue(ls.profileImg);
    if (savedProfileImg.isNotEmpty) {
      profileController.profileImageUrl.value = savedProfileImg;
    }

    print("Loaded profile image: $savedProfileImg");
    isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(ConstStrings().profileTxt, style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600),),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              print("get back");
              Get.toNamed(RouteHelper().getHomeScreen());
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.delete, color: ConstColors().themeColor),
              onPressed: () {
                print("before delete api call");
                CommonFunctions().alertDialog(
                  "Alert",
                  "Are you sure, you want to delete this account?",
                  "Ok",
                  () {
                    profileController.deleteApi(userId.value);
                  },
                  isAlert: true,
                );
              },
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: Obx(() {
          if (isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 15.0,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: InkWell(
                              onTap: () async {
                                await UploadImageDialog.show(context, () async {
                                  Get.back();
                                  await CommonFunctions().pickImage(
                                      ImageSource.camera,
                                      profileController.imageFile
                                  );

                                  if (profileController.imageFile.value != null) {
                                    await profileController.updateProfileApi(
                                        profileController.imageFile.value!.path
                                    );
                                  }
                                }, () async {
                                  Get.back();
                                  await CommonFunctions().pickImage(
                                      ImageSource.gallery,
                                      profileController.imageFile
                                  );

                                  if (profileController.imageFile.value != null) {
                                    await profileController.updateProfileApi(
                                        profileController.imageFile.value!.path
                                    );
                                  }
                                });
                              },
                              child: Obx(() {
                                if (profileController.imageFile.value != null &&
                                    profileController.imageFile.value!.path.isNotEmpty) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(60),
                                    child: Image.file(
                                      profileController.imageFile.value!,
                                      height: 10.h,
                                      width: 10.h,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                } else if (profileController.profileImageUrl.value.isNotEmpty &&
                                    profileController.profileImageUrl.value != "null") {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(60),
                                    child: Image.network(
                                      profileController.profileImageUrl.value,
                                      height: 10.h,
                                      width: 10.h,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                } else {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(60),
                                    child: Image.asset(
                                      AssetsImages().profileImage,
                                      height: 10.h,
                                      width: 10.h,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                }
                              }),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    isEditing.value
                                        ? Expanded(
                                            child:
                                                CommonWidgets.customTextField(
                                              controller: fullnameController,
                                              keyboardType: TextInputType.name,
                                              hintText: ConstStrings()
                                                  .enterYourFullNameTxt,
                                              prefixIcon: Icons.person_outline,
                                              validator: validateName,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(
                                                        RegExp(r'[a-zA-Z\s]')),
                                                LengthLimitingTextInputFormatter(
                                                    25),
                                              ],
                                            ),
                                          )
                                        : Expanded(
                                            child: Text(
                                              fullnameController.text,
                                              style: const TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                    const SizedBox(width: 8),
                                    TextButton(
                                      onPressed: () {
                                        /* if (isEditing.value) {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            profileController.updateUserDataApi(
                                              userId.value,
                                              fullnameController.text,
                                              mobileNumberController.text,
                                              emailController.text,
                                            );
                                            isEditing.value = false;
                                          }
                                        } else {
                                          isEditing.value = true;
                                        }*/

                                        if (isEditing.value) {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            String newNumber =
                                                mobileNumberController.text
                                                    .trim();
                                            String oldNumber =
                                                ls.getStringValue(
                                                    ls.mobileNumber);

                                            if (newNumber != oldNumber) {
                                              CommonFunctions()
                                                  .showOtpBottomSheet(
                                                newNumber,
                                                "update_number",
                                                (otp) {
                                                  authController
                                                      .verifyOtpApi(newNumber,
                                                          otp, "update_number")
                                                      .then((verified) {
                                                    if (verified) {
                                                      profileController
                                                          .updateUserDataApi(
                                                        userId.value,
                                                        fullnameController.text,
                                                        newNumber,
                                                        emailController.text,
                                                      );
                                                      isEditing.value = false;
                                                    }
                                                  });
                                                },
                                                () {
                                                  // Resend OTP tap
                                                },
                                              );
                                            } else {
                                              profileController
                                                  .updateUserDataApi(
                                                userId.value,
                                                fullnameController.text,
                                                newNumber,
                                                emailController.text,
                                              );
                                              isEditing.value = false;
                                            }
                                          }
                                        } else {
                                          isEditing.value = true;
                                        }
                                      },
                                      child: Text(
                                        isEditing.value ? "Update" : "Edit",
                                        style: TextStyle(
                                          color: ConstColors().themeColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                isEditing.value
                                    ? CommonWidgets.customTextField(
                                        controller: mobileNumberController,
                                        keyboardType: TextInputType.number,
                                        hintText:
                                            ConstStrings().enterMobileNumberTxt,
                                        prefixIcon: Icons.phone_android,
                                        validator: validateMobile,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(10),
                                        ],
                                      )
                                    : Text(
                                        "+91 ${mobileNumberController.text}",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14.sp),
                                      ),
                                const SizedBox(height: 5),
                                isEditing.value
                                    ? CommonWidgets.customTextField(
                                        controller: emailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        hintText: ConstStrings().yourEmailIdTxt,
                                        prefixIcon: Icons.mail_outline,
                                        validator: validateEmail,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(50),
                                        ],
                                      )
                                    : Text(
                                        emailController.text,
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14.sp),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      ListTile(
                        onTap: () {
                          Get.toNamed(RouteHelper().getMyCarScreen());
                        },
                        leading: Image.asset(
                          AssetsImages().mapCarWash,
                          height: 35,
                        ),
                        title: Text(
                          ConstStrings().myCarsCollectionTxt,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          ConstStrings().addAndManageYourVehiclesTxt,
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Get.toNamed(RouteHelper().getSavedAddressScreen());
                          print("saved address");
                        },
                        leading: Image.asset(
                          AssetsImages().locationIcon,
                          height: 35,
                        ),
                        title: const Text(
                          "Saved Address",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text("You can edit your address"),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      ),
                      /*  ListTile(
                        onTap: () {
                          Get.toNamed(RouteHelper().getPaymentBreakdownScreen());
                        },
                        leading: Image.asset(
                          AssetsImages().contact,
                          height: 35,
                        ),
                        title: const Text(
                          "Payments",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text("manage your payment"),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      ),
                    ListTile(
                        leading: Image.asset(
                          AssetsImages().driverDostImage,
                          height: 35,
                        ),
                        title: const Text(
                          "Driver dost",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text(
                            "Join as driver partner Drive together, earn together"),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {},
                      ),*/
                      ListTile(
                        onTap: () {
                          Get.toNamed(RouteHelper().getReferAndEarnPage());
                        },
                        leading: Image.asset(
                          AssetsImages().rupeesIcon,
                          height: 35,
                        ),
                        title: const Text(
                          "Refer & Earn",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text(
                            "Share your referral code with friends."),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      ),
                      ListTile(
                        onTap: () {
                          Get.toNamed(RouteHelper().getFaqScreen());
                        },
                        leading: Image.asset(
                          AssetsImages().questionMark,
                          height: 35,
                        ),
                        title: const Text(
                          "FAQ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text(
                            "Share your referral code with friends."),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      ),
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text(
                          "Logout",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          CommonFunctions().alertDialog(
                            "Alert",
                            "Are you sure you want to logout?",
                            "Ok",
                            () async {
                              Get.back();
                              await authController.logoutApi();
                            },
                            isAlert: true,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }),
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
    if (!RegExp(pattern).hasMatch(value.trim())) {
      return "Please enter a valid mobile number";
    }
    if (_numberError.value != "") return _numberError.value;
    return null;
  }
}
