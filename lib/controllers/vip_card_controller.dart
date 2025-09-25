import 'package:get/get.dart';

import '../repositories/vip_card_repository.dart';

class VipCardController extends GetxController {
  var carouselImages = <String>[].obs;
  var price = "".obs;
  var isLoading = true.obs;

  final VipCardRepository _vipCardRepository = Get.find<VipCardRepository>();

  @override
  void onInit() {
    super.onInit();
    fetchVipCardData();
  }

  void fetchVipCardData() async {
    try {
      isLoading(true);
      final data = await _vipCardRepository.getVipCardData();
      carouselImages.assignAll(data.carouselImages);
      price.value = data.price;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}
