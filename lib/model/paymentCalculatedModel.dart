// To parse this JSON data, do
//
//     final paymentCalModel = paymentCalModelFromJson(jsonString);

import 'dart:convert';

PaymentCalModel paymentCalModelFromJson(String str) => PaymentCalModel.fromJson(json.decode(str));

String paymentCalModelToJson(PaymentCalModel data) => json.encode(data.toJson());

class PaymentCalModel {
  int bookingId;
  String startTime;
  int expectedEnd;
  String endTime;
  String type;
  String extra;

  PaymentCalModel({
    required this.bookingId,
    required this.startTime,
    required this.expectedEnd,
    required this.endTime,
    required this.type,
    required this.extra,
  });

  factory PaymentCalModel.fromJson(Map<String, dynamic> json) => PaymentCalModel(
    bookingId: json["bookingId"],
    startTime: json["startTime"],
    expectedEnd: json["expectedEnd"],
    endTime: json["endTime"],
    type: json["type"],
    extra: json["extra"],
  );

  Map<String, dynamic> toJson() => {
    "bookingId": bookingId,
    "startTime": startTime,
    "expectedEnd": expectedEnd,
    "endTime": endTime,
    "type": type,
    "extra": extra,
  };
}
