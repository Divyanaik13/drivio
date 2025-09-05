class WebService{

  static final WebService _webService = WebService._internal();
  factory WebService(){
    return _webService;
  }
  WebService._internal();

  var baseUrl = "https://docapi.nuke.co.in/api/user/auth";

  var signUpApi = "/register";
  var loginApi = "/login";
  var verifyTopApi = "/verify-otp";
  var logoutApi = "/logout";
  var editProfileApi = "/updateUser";
  var deleteUserApi = "/deleteUser";
}