// To parse this JSON data, do
//
//     final paymentCalModel = paymentCalModelFromJson(jsonString);

import 'dart:convert';

PaymentCalModel paymentCalModelFromJson(String str) => PaymentCalModel.fromJson(json.decode(str));

String paymentCalModelToJson(PaymentCalModel data) => json.encode(data.toJson());

class PaymentCalModel {
  Data data;

  PaymentCalModel({
    required this.data,
  });

  factory PaymentCalModel.fromJson(Map<String, dynamic> json) => PaymentCalModel(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  String type;
  int plannedHours;
  int ratePerHour;
  int planAmount;
  int actualMinutes;
  int plannedMinutes;
  int overtimeMinutes;
  int nightCharges;
  int platformFees;
  int extraCharges;
  bool isExtraOnly;
  int subTotal;
  int totalAmount;
  Discount discount;

  Data({
    required this.type,
    required this.plannedHours,
    required this.ratePerHour,
    required this.planAmount,
    required this.actualMinutes,
    required this.plannedMinutes,
    required this.overtimeMinutes,
    required this.nightCharges,
    required this.platformFees,
    required this.extraCharges,
    required this.isExtraOnly,
    required this.subTotal,
    required this.totalAmount,
    required this.discount,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    type: json["type"],
    plannedHours: json["plannedHours"],
    ratePerHour: json["ratePerHour"],
    planAmount: json["planAmount"],
    actualMinutes: json["actualMinutes"],
    plannedMinutes: json["plannedMinutes"],
    overtimeMinutes: json["overtimeMinutes"],
    nightCharges: json["nightCharges"],
    platformFees: json["platformFees"],
    extraCharges: json["extraCharges"],
    isExtraOnly: json["isExtraOnly"],
    subTotal: json["subTotal"],
    totalAmount: json["totalAmount"],
    discount: Discount.fromJson(json["discount"]),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "plannedHours": plannedHours,
    "ratePerHour": ratePerHour,
    "planAmount": planAmount,
    "actualMinutes": actualMinutes,
    "plannedMinutes": plannedMinutes,
    "overtimeMinutes": overtimeMinutes,
    "nightCharges": nightCharges,
    "platformFees": platformFees,
    "extraCharges": extraCharges,
    "isExtraOnly": isExtraOnly,
    "subTotal": subTotal,
    "totalAmount": totalAmount,
    "discount": discount.toJson(),
  };
}

class Discount {
  dynamic code;
  int percent;
  int amount;

  Discount({
    required this.code,
    required this.percent,
    required this.amount,
  });

  factory Discount.fromJson(Map<String, dynamic> json) => Discount(
    code: json["code"],
    percent: json["percent"],
    amount: json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "percent": percent,
    "amount": amount,
  };
}
