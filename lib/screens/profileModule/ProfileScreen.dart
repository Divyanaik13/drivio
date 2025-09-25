import 'package:drivio_sarthi/utils/CommonFunctions.dart';
import 'package:drivio_sarthi/utils/ConstStrings.dart';
import 'package:drivio_sarthi/utils/RouteHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../controllers/AuthController.dart';
import '../../controllers/profileController.dart';
import '../../utils/AssetsImages.dart';
import '../../utils/ConstColors.dart';
import '../../utils/LocalStorage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var authController = Get.find<AuthController>();
  var profileController = Get.find<ProfileController>();

  LocalStorage ls = LocalStorage();

  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  var isEditing = false.obs;
  var userId = "".obs;
  var isLoading = true.obs;

  @override
  void initState() {
    super.initState();
    _loadUserData();
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
    isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(ConstStrings().profileTxt),
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
                vertical: 20.0,
              ),
              child: SingleChildScrollView(
                  child: Column(
                   children: [
                   Row(
                    children: [
                      SizedBox(

                      ),
                       Container(
                         decoration: BoxDecoration(
                           border: Border.all(color: Colors.grey),
                           borderRadius: BorderRadius.circular(50),
                         ),
                         child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(AssetsImages().profileImage,height: 11.h,)),
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
                                        child: TextField(
                                          controller: fullnameController,
                                          keyboardType: TextInputType.name,
                                          decoration: InputDecoration(
                                            labelText:
                                                ConstStrings().fullNameTxt,
                                          ),
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(
                                              25,
                                            ),
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
                                    if (isEditing.value) {
                                      /// Update profile api
                                      profileController.updateProfileApi(
                                          userId.value,
                                          fullnameController.text,
                                          mobileNumberController.text,
                                          emailController.text);
                                      isEditing.value = false;
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
                            isEditing.value
                                ? TextField(
                                    controller: mobileNumberController,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      labelText: ConstStrings().mobileNumberTxt,
                                    ),
                                  )
                                : Text(
                                    "+91 ${mobileNumberController.text}",
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                            const SizedBox(height: 5),
                            isEditing.value
                                ? TextField(
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      labelText: ConstStrings().emailTxt,
                                    ),
                                  )
                                : Text(
                                    emailController.text,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  ListTile(
                    leading: const Icon(
                      Icons.directions_car,
                      color: Colors.green,
                    ),
                    title: Text(
                      ConstStrings().myCarsCollectionTxt,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      ConstStrings().addAndManageYourVehiclesTxt,
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.location_on,
                      color: Colors.green,
                    ),
                    title: const Text(
                      "Saved Address",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text("You can edit your address"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.article, color: Colors.green),
                    title: const Text(
                      "Report",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text("Generate & See Resume"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
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
              )),
            );
          }
        }),
        backgroundColor: const Color(0xFFFAFAF4),
      ),
    );
  }
}
