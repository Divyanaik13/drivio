import '../network/ApiService.dart';
import '../network/WebService.dart';
import '../utils/CommonFunctions.dart';

class ProfileRepo{

  /// update/edit profile function
  Future<dynamic> updateProfileRepo(String id, fullname, mobileNumber, email) async{
    CommonFunctions().showLoader();
    var response;
    Map<String, dynamic> bodyMap = {
      "fullname" : fullname,
      "email" : email,
      "mobileNumber" : mobileNumber,
    };
    print("update Profile Repo bodyMap :-- $bodyMap");
    try{
      var header = await DioServices().getAllHeaders();
      response = await DioServices().putMethod(
          "${WebService().editProfileApi}?id=$id",
          bodyMap, header);
      print("edit profile header :-- $header");
      print("url :-- ${WebService().editProfileApi}?id=$id");
      print("update Profile Repo response :-- $response");
    }catch(e){
      print("update Profile Repo response :-- $e");
    }
    return response;
  }

  /// Delete user repo function
  Future<Map<String, dynamic>> deleteUserRepo(String id) async {
    var response;
    var header = await DioServices().getAllHeaders();
    try {
      response = await DioServices().deleteData("${WebService().deleteUserApi}?id=$id",
          header, null);
      print("delete header :-- $header");
      print("delete user repo response:-- $response");
      return response;
    } catch (e) {
      print("Delete user repo error :-- $e");
      return {"success": 0, "message": "Exception: $e", "error": {}};
    }
  }

}