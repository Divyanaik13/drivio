class VipCardModel {
  late final String id;
  late final String title;
  late final String description;
  late final String imageUrl;
  late final List<String> carouselImages;
  late final bool isActive;
  late final String price;

  VipCardModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.carouselImages,
    required this.isActive,
    required this.price,
  });

  factory VipCardModel.fromJson(Map<String, dynamic> json) {
    return VipCardModel(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        imageUrl: json['image_url'] as String,
        carouselImages:
            List<String>.from(json['carousel_images']).map((x) => x).toList(),
        isActive: json['is_active'] as bool,
        price: json['price'] as String);
  }
}
