import 'package:drivio_sarthi/utils/CommonFunctions.dart';
import 'package:drivio_sarthi/utils/ConstStrings.dart';
import 'package:drivio_sarthi/utils/RouteHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/AuthController.dart';
import '../../network/auth_api.dart';
import '../../utils/LocalStorage.dart';
import '../authModule/loginScreen.dart';
import 'HomeScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditing = false;
  var authController = Get.find<AuthController>();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();

  String userId = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await LocalStorage.getUserData();
    if (user != null) {
      setState(() {
        userId = user["id"].toString();
        fullnameController.text = user["fullname"] ?? "";
        emailController.text = user["email"] ?? "";
        mobileNumberController.text = user["mobileNumber"] ?? "";
        print("user :-- $user");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ConstStrings().profileTxt),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          },
        ),
        actions: [
          // ProfileScreen
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              print("before delete api call");
              if (userId.isNotEmpty) {
                /*AuthApi.deleteUser(
                  context: context,
                  id: userId,
                  onSuccess: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear();
                    print("after delete api call");

                    final navigatorContext = context;

                    Navigator.pop(navigatorContext);

                    Future.delayed(const Duration(milliseconds: 300), () {
                      Navigator.pushAndRemoveUntil(
                        navigatorContext,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                            (route) => false,
                      );
                    });
                  },
                );*/
              }
            },
          ),

          const SizedBox(width: 10),
        ],
      ),
      body:
          fullnameController.text.isEmpty && mobileNumberController.text.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 20.0,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                            "https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?cs=srgb&dl=pexels-italo-melo-881954-2379004.jpg&fm=jpg",
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  isEditing
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
                                      if (isEditing) {
                                        //_updateProfile();
                                      } else {
                                        setState(() => isEditing = true);
                                      }
                                    },
                                    child: Text(
                                      isEditing ? "Update" : "Edit",
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              isEditing
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
                              isEditing
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
                            await authController.logoutApi();
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
      backgroundColor: const Color(0xFFFAFAF4),
    );
  }

  /* void _updateProfile() {
    AuthApi.updateUserProfile(
      context,
      id: userId,
      fullname: fullnameController.text.trim(),
      mobileNumber: mobileNumberController.text.trim(),
      email: emailController.text.trim(),
      onSuccess: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("fullname", fullnameController.text.trim());
        await prefs.setString(
          "mobileNumber",
          mobileNumberController.text.trim(),
        );
        await prefs.setString("email", emailController.text.trim());
        print("prefs :-- ${prefs}");
        setState(() {
          isEditing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully")),
        );
      },
    );
  }*/

  /*void _updateProfile() async {
    if (userId.isEmpty) return;

    int? mobile;
    try {
      mobile = int.parse(mobileNumberController.text.trim());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid mobile number")),
      );
      return;
    }

    await AuthApi.updateUserProfile(
      context: context,
      id: userId,
      fullname: fullnameController.text.trim(),
      email: emailController.text.trim(),
      mobileNumber: mobileNumberController.text.trim(), // send as int
      onSuccess: (data) {
        setState(() {
          isEditing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully")),
        );
      },
    );
  }*/
}
