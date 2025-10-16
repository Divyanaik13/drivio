class WebService{

  static final WebService _webService = WebService._internal();
  factory WebService(){
    return _webService;
  }
  WebService._internal();


  var baseUrl = "https://docapi.nuke.co.in/api/";

  var signUpApi = "user/auth/register";
  var loginApi = "user/auth/login";
  var verifyTopApi = "user/auth/verify-otp";
  var logoutApi = "user/auth/logout";
  var editProfileApi = "user/auth/updateUser";
  var deleteUserApi = "user/auth/deleteUser";
  var getReferCodeApi = "user/auth/getReferCode";
  var getSearchHistoryApi = "user/search-history";
  var vipCardApi = "user/search-history"; //endpoint has to be change
  var updateProfile = "user/auth/uploadProfile";
  var profileOtpVerify = "user/auth/verifyOTPforUpdate";
  var bookingBeforeAcceptApi = "user/auth/bookingBeforeAccept";
  var getCalculatedPaymentApi = "user/auth/getCalculatedPaymentBreakdown";
  var getSaveAddressApi = "user/auth/saveAddress";
  var addCarApi = "user/auth/createcar";
  var getAllCarCollection = "user/auth/getAllCarByMobileNumber";
  var getVipOffer = "user/auth/getOffers";
}