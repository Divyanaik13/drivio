import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/terms_and_condition_model.dart';

class TermsAndConditionController extends GetxController {
  var termsData = Rxn<TermsAndConditionsModel>();
  var isLoading = true.obs;
  var hasError = false.obs;
  final String apiUrl = 'https://mocki.io/v1/f3ece97b-3afe-46c0-b42b-2d8e12d4738c';

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchTerms();
  }

  void fetchTerms() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        termsData.value = TermsAndConditionsModel.fromJson(data);
      } else {
        hasError.value = true;
        Get.snackbar('Error', 'Failed to load terms and conditions');
      }
    } catch (e) {
      hasError.value = true;
      Get.snackbar('Error', 'network error');
    } finally {
      isLoading.value = false;
    }
  }
}
