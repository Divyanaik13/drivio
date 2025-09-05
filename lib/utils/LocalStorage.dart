import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _userKey = "user_data";
  static const String _tokenKey = "auth_token";

  /// Save user + token
  static Future<void> saveUserData(Map<String, dynamic> user, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user));
    await prefs.setString(_tokenKey, token);
  }

  /// Get user data
  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString(_userKey);
    if (userJson != null) {
      return jsonDecode(userJson);
    }
    return null;
  }

  /// Get token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Clear all user data (Logout)
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

/*import 'package:get_storage/get_storage.dart';

class LocalStorage {
  static final LocalStorage _function = LocalStorage._internal();

  factory LocalStorage(){
    return _function;
  }
  LocalStorage._internal();

  final localStorage = GetStorage();

 /// keys
  String authToken = "token";
  String fullname = "fullname";
  String email = "email";
  String mobileNumber = "mobileNumber";
  String referral = "referral";
  String referralCount = "referralCount";

  //For Storing String value
  void setStringValue(String key, String value){
    localStorage.write(key, value);
  }

  String getStringValue(String key){
    return localStorage.read(key)??"";
  }

  //For Storing Bool value
  void setBoolValue(String key, bool value){
    localStorage.write(key, value);
  }

  bool getBoolValue(String key){
    return localStorage.read(key)?? false;
  }

  //For Storing Integer value
  void setNumValue(String key, String value){
    localStorage.write(key, value);
  }

  int getNumValue(String key){
    return localStorage.read(key);
  }

  //For Storing String value
  void setListValue(String key, List<dynamic> value){
    localStorage.write(key, value);
  }

  List<dynamic> getListValue(String key){
    return localStorage.read(key)?? [];
  }


  //For Clear the GetStorage
  void clearLocalStorage(){
    localStorage.erase();
    //StripeDioServices().cardList.clear();
    //ConstStrings().tabIndex.value = 0;
    print("clearLocalStorage");
  }
}*/
