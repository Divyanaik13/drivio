/*
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/authModule/loginScreen.dart';
import '../utils/CommonWidgets.dart';

class AuthApi {
  static const String baseUrl = "https://docapi.nuke.co.in/api/user/auth";

  static Future<Map<String, dynamic>> signUpApi(
      BuildContext context,
      String fullname,
      String mobileNumber,
      ) async {
    CommonWidgets.showLoader(context);
    Map<String, String> body = {
      "fullname": fullname,
      "mobileNumber": mobileNumber,
    };

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);
      print("sign data :-- $data");
      CommonWidgets.hideLoader(context);
      return data;
    } catch (e) {
      CommonWidgets.hideLoader(context);
      return {"success": 0, "message": "Something went wrong"};
    }
  }

  static Future<void> verifySignUpOtp(
      BuildContext context,
      String fullname,
      String mobileNumber,
      String otp,
      Function(dynamic response) onSuccess,
      ) async {
    CommonWidgets.showLoader(context);
    Map<String, String> body = {
      "fullname": fullname,
      "mobileNumber": mobileNumber,
      "otp": otp,
    };

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/verify-otp"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);
      print("sign verify otp data :-- $data");

      CommonWidgets.hideLoader(context);
    */
/*  if (response.statusCode == 200) {
        if (data["token"] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("token", data["token"]);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP Verified")),
        );
        onSuccess();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "OTP verification failed")),
        );
      }*//*

      if (response.statusCode == 200 &&
          data["data"] != null &&
          data["data"]["token"] != null) {
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString("token", data["data"]["token"]);

        final user = data["data"]["user"];
        if (user != null) {
          await prefs.setString("id", user["id"].toString());
          await prefs.setString("fullname", user["fullname"] ?? "");
          await prefs.setString("mobileNumber", user["mobileNumber"] ?? "");
          await prefs.setString("email", user["email"] ?? "");
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP Verified")),
        );

        onSuccess(data);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "OTP verification failed")),
        );
      }
    } catch (e) {
      CommonWidgets.hideLoader(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong")),
      );
    }
  }

  static Future<Map<String, dynamic>> loginApi(
      BuildContext context,
      String mobileNumber,
      ) async {
    CommonWidgets.showLoader(context);
    Map<String, String> body = {"mobileNumber": mobileNumber};

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);
      print("login data :-- $data");

      CommonWidgets.hideLoader(context);

      if (response.statusCode == 200) {
        return {"success": 1, "message": "OTP Sent"};
      } else {
        return {"success": 0, "message": data["message"] ?? "Number not registered"};
      }
    } catch (e) {
      CommonWidgets.hideLoader(context);
      return {"success": 0, "message": "Something went wrong"};
    }
  }


  static Future<void> verifyLoginOtp(
      BuildContext context,
      String mobileNumber,
      String otp,
      Function(dynamic response) onSuccess,
      ) async {
    CommonWidgets.showLoader(context);

    Map<String, dynamic> body = {
      "mobileNumber": int.parse(mobileNumber),
      "otp": int.parse(otp),
      "type": "login",
    };

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/verify-otp"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);
      print("verifyLoginOtp response: $data");

      CommonWidgets.hideLoader(context);

      if (response.statusCode == 200 &&
          data["data"] != null &&
          data["data"]["token"] != null) {
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString("token", data["data"]["token"]);

        final user = data["data"]["user"];
        if (user != null) {
          await prefs.setString("id", user["id"].toString());
          await prefs.setString("fullname", user["fullname"] ?? "");
          await prefs.setString("mobileNumber", user["mobileNumber"] ?? "");
          await prefs.setString("email", user["email"] ?? "");
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP Verified")),
        );

        onSuccess(data);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "OTP verification failed")),
        );
      }
    } catch (e) {
      CommonWidgets.hideLoader(context);
      print("verifyLoginOtp error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong")),
      );
    }
  }


  static Future<void> logout(BuildContext context, VoidCallback onSuccess) async {
    CommonWidgets.showLoader(context);
    try {
      final response = await http.get(Uri.parse("$baseUrl/logout"));
      CommonWidgets.hideLoader(context);

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove("auth_token");

        onSuccess();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Logged out successfully")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Logout failed")),
        );
      }
    } catch (e) {
      CommonWidgets.hideLoader(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong")),
      );
    }
  }

*/
/*  static Future<void> updateUserProfile(
      BuildContext context, {
        required String id,
        required String fullname,
        required String mobileNumber,
        required String email,
        required VoidCallback onSuccess,
      }) async {
    CommonWidgets.showLoader(context);

    Map<String, String> body = {
      "fullname": fullname,
      "mobileNumber": mobileNumber,
      "email": email,
    };

    try {
      final response = await http.put(
        Uri.parse("$baseUrl/updateUser?id=$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);
      print("Update Profile Response: $data");

      CommonWidgets.hideLoader(context);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully")),
        );
        onSuccess();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Profile update failed")),
        );
      }
    } catch (e) {
      CommonWidgets.hideLoader(context);
      print("Error updating profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong")),
      );
    }
  }*//*

  static Future<void> updateUserProfile({
    required BuildContext context,
    required String id,
    required String fullname,
    required String email,
    required String mobileNumber,
    required Function(dynamic response) onSuccess,
  }) async {
    CommonWidgets.showLoader(context);

    Map<String, dynamic> body = {
      "fullname": fullname,
      "email": email,
      "mobileNumber": mobileNumber,
    };


    try {
      final response = await http.put(
        Uri.parse("$baseUrl/updateUser?id=$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);
      print("updateUserProfile response: $data");

      CommonWidgets.hideLoader(context);

      if (response.statusCode == 200 && data["success"] == 1) {
        // Update local storage
        final prefs = await SharedPreferences.getInstance();
        final user = data["data"]["user"];
        if (user != null) {
          await prefs.setString("id", user["id"].toString());
          await prefs.setString("fullname", user["fullname"] ?? "");
          await prefs.setString("email", user["email"] ?? "");
          await prefs.setString("mobileNumber", user["mobileNumber"] ?? "");
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully")),
        );

        onSuccess(data);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Failed to update profile")),
        );
      }
    } catch (e) {
      CommonWidgets.hideLoader(context);
      print("updateUserProfile error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong")),
      );
    }
  }



  static Future<void> deleteUser({
    required BuildContext context,
    required String id,
    required VoidCallback onSuccess,
  }) async {
    final scaffoldContext = context;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Delete Account"),
          content: const Text(
              "Are you sure you want to delete your account? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                Navigator.pop(dialogContext); // close dialog
                CommonWidgets.showLoader(scaffoldContext);

                try {
                  final response = await http.delete(
                    Uri.parse("$baseUrl/deleteUser?id=$id"),
                    headers: {"Content-Type": "application/json"},
                  );

                  CommonWidgets.hideLoader(scaffoldContext);

                  final data = jsonDecode(response.body);
                  print("delete data :-- $data");

                  if (response.statusCode == 200 && data["success"] == 1) {
                    // delay to ensure dialog closed
                    await Future.delayed(const Duration(milliseconds: 300));

                    // use saved scaffold context for SnackBar & navigation
                    ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                      const SnackBar(content: Text("User deleted successfully")),
                    );

                    onSuccess(); // now safe to navigate
                  } else {
                    ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                      SnackBar(
                          content:
                          Text(data["message"] ?? "Failed to delete user")),
                    );
                  }
                } catch (e) {
                  CommonWidgets.hideLoader(scaffoldContext);
                  print("Error deleting user: $e");
                  ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                    const SnackBar(content: Text("Something went wrong")),
                  );
                }
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
*/
