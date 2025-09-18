class WebService{

  static final WebService _webService = WebService._internal();
  factory WebService(){
    return _webService;
  }
  WebService._internal();

  var baseUrl = "https://docapi.nuke.co.in/api/user";

  var signUpApi = "/auth/register";
  var loginApi = "/auth/login";
  var verifyTopApi = "/auth/verify-otp";
  var logoutApi = "/auth/logout";
  var editProfileApi = "/auth/updateUser";
  var deleteUserApi = "/auth/deleteUser";
  var getReferCodeApi = "/auth/getReferCode";
  var getSearchHistoryApi = "/search-history";
}