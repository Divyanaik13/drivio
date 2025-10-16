// To parse this JSON data, do
//
//     final vipCardModel = vipCardModelFromJson(jsonString);

import 'dart:convert';

VipCardModel vipCardModelFromJson(String str) => VipCardModel.fromJson(json.decode(str));

String vipCardModelToJson(VipCardModel data) => json.encode(data.toJson());

class VipCardModel {
  int success;
  String message;
  List<VipCardList> data;
  dynamic error;

  VipCardModel({
    required this.success,
    required this.message,
    required this.data,
    required this.error,
  });

  factory VipCardModel.fromJson(Map<String, dynamic> json) => VipCardModel(
    success: json["success"],
    message: json["message"],
    data: List<VipCardList>.from(json["data"].map((x) => VipCardList.fromJson(x))),
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "error": error,
  };
}

class VipCardList {
  int id;
  String type;
  String offerTitle;
  String offerPrice;
  String offerDescription;
  String offerImageUrl;
  DateTime createdAt;
  DateTime updatedAt;

  VipCardList({
    required this.id,
    required this.type,
    required this.offerTitle,
    required this.offerPrice,
    required this.offerDescription,
    required this.offerImageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VipCardList.fromJson(Map<String, dynamic> json) => VipCardList(
    id: json["id"],
    type: json["type"],
    offerTitle: json["offer_title"],
    offerPrice: json["offer_price"],
    offerDescription: json["offer_description"],
    offerImageUrl: json["offer_image_url"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "offer_title": offerTitle,
    "offer_price": offerPrice,
    "offer_description": offerDescription,
    "offer_image_url": offerImageUrl,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
