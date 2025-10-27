// To parse this JSON data, do
//
//     final searchHistoryListModel = searchHistoryListModelFromJson(jsonString);

import 'dart:convert';

SearchHistoryListModel searchHistoryListModelFromJson(String str) => SearchHistoryListModel.fromJson(json.decode(str));

String searchHistoryListModelToJson(SearchHistoryListModel data) => json.encode(data.toJson());

class SearchHistoryListModel {
  int success;
  String message;
  List<SearchHistoryList> data;
  Pagination pagination;
  dynamic error;

  SearchHistoryListModel({
    required this.success,
    required this.message,
    required this.data,
    required this.pagination,
    required this.error,
  });

  factory SearchHistoryListModel.fromJson(Map<String, dynamic> json) => SearchHistoryListModel(
    success: json["success"],
    message: json["message"],
    data: List<SearchHistoryList>.from(json["data"].map((x) => SearchHistoryList.fromJson(x))),
    pagination: Pagination.fromJson(json["pagination"]),
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "pagination": pagination.toJson(),
    "error": error,
  };
}

class SearchHistoryList {
  int id;
  String userName;
  int userPhoneNumber;
  String lateLog;
  String address;
  String device;
  dynamic ipAddress;
  dynamic city;
  dynamic state;
  dynamic country;
  dynamic postalCode;
  dynamic notes;
  DateTime occurredAt;
  DateTime createdAt;
  DateTime updatedAt;
  double? latitude;
  double? longitude;

  SearchHistoryList({
    required this.id,
    required this.userName,
    required this.userPhoneNumber,
    required this.lateLog,
    required this.address,
    required this.device,
    required this.ipAddress,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    required this.notes,
    required this.occurredAt,
    required this.createdAt,
    required this.updatedAt,
    this.latitude,
    this.longitude,
  });

  factory SearchHistoryList.fromJson(Map<String, dynamic> json) => SearchHistoryList(
    id: json["id"],
    userName: json["user_name"],
    userPhoneNumber: json["user_phoneNumber"],
    lateLog: json["lateLog"],
    address: json["address"],
    device: json["device"],
    ipAddress: json["ip_address"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    postalCode: json["postal_code"],
    notes: json["notes"],
    occurredAt: DateTime.parse(json["occurred_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    latitude: json["latitude"] != null
        ? double.tryParse(json["latitude"].toString())
        : null,
    longitude: json["longitude"] != null
        ? double.tryParse(json["longitude"].toString())
        : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_name": userName,
    "user_phoneNumber": userPhoneNumber,
    "lateLog": lateLog,
    "address": address,
    "device": device,
    "ip_address": ipAddress,
    "city": city,
    "state": state,
    "country": country,
    "postal_code": postalCode,
    "notes": notes,
    "occurred_at": occurredAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "latitude": latitude,
    "longitude": longitude,
  };
}

class Pagination {
  int page;
  int limit;
  int total;
  int pages;

  Pagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.pages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    page: json["page"],
    limit: json["limit"],
    total: json["total"],
    pages: json["pages"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "limit": limit,
    "total": total,
    "pages": pages,
  };
}
