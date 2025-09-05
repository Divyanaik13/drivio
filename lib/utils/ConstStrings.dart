class ConstStrings{

  static final ConstStrings _constStrings = ConstStrings._internal();
  factory ConstStrings(){
    return _constStrings;
  }
  ConstStrings._internal();

  /// Login screen text
  String drivTxt = "Driv";
  String ioTxt = "io";
  String logInTxt = "Log in";
  String enterMobileNumberTxt = "Enter mobile number";
  String continueTxt = "Continue";
  String dontHaveAnAccountTxt = "Don't have an account? ";
  String signUpTxt = "Sign up";

  /// Sign-up screen text
  String enterYourFullNameTxt = "Enter your full name";
  String yourEmailIdTxt = "Your email id";
  String referralCodeTxt = "Referral Code (optional)";
  String wellUseYourPhoneNumberTxt = "We’ll use your phone number and email only for driver notifications and receipts.";
  String bySigningInYouAgreeToYourTxt = 'By signing in, you agree to our ';
  String termsAndConditionsTxt = 'Terms & Conditions';
  String andTxt = ' and';
  String privacyPolicyTxt = ' Privacy Policy';
  String alreadyHaveAnAccountTxt = "Already have an account? ";
  String loginTxt = "Login";

  /// Profile screen text
  String profileTxt = "Profile";
  String fullNameTxt = "Full Name";
  String mobileNumberTxt = 'Mobile Number';
  String emailTxt = 'Email';
  String myCarsCollectionTxt = "My cars collection";
  String addAndManageYourVehiclesTxt = "Add & manage your vehicles";
  String successTxt = "Success";
  String alertTxt = "Alert";
  String noInternetTxt = "No internet";
  String okTxt = "Ok";
}