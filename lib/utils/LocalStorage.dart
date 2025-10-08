import 'package:get_storage/get_storage.dart';

class LocalStorage {
  static final LocalStorage _function = LocalStorage._internal();

  factory LocalStorage(){
    return _function;
  }
  LocalStorage._internal();

  final localStorage = GetStorage();

 /// keys
  String authToken = "token";
  String userId = "id";
  String fullName = "fullname";
  String email = "email";
  String mobileNumber = "mobileNumber";
  String referral = "referral";
  String myCoins = "myCoins";
  String isFirstLaunch = "isFirstLaunch";
  String profileImg = "profileImg";

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
    print("clearLocalStorage");
  }
}
