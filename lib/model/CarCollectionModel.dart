// To parse this JSON data, do
//
//     final carCollectionModel = carCollectionModelFromJson(jsonString);

import 'dart:convert';

CarCollectionModel carCollectionModelFromJson(String str) => CarCollectionModel.fromJson(json.decode(str));

String carCollectionModelToJson(CarCollectionModel data) => json.encode(data.toJson());

class CarCollectionModel {
  int success;
  String message;
  Data data;
  dynamic error;

  CarCollectionModel({
    required this.success,
    required this.message,
    required this.data,
    required this.error,
  });

  factory CarCollectionModel.fromJson(Map<String, dynamic> json) => CarCollectionModel(
    success: json["success"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.toJson(),
    "error": error,
  };
}

class Data {
  Car car;

  Data({
    required this.car,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    car: Car.fromJson(json["car"]),
  );

  Map<String, dynamic> toJson() => {
    "car": car.toJson(),
  };
}

class Car {
  int id;
  String carname;
  String ownername;
  String carNumber;
  String transmissionType;
  int userId;
  String username;
  String userNumber;
  DateTime updatedAt;
  DateTime createdAt;

  Car({
    required this.id,
    required this.carname,
    required this.ownername,
    required this.carNumber,
    required this.transmissionType,
    required this.userId,
    required this.username,
    required this.userNumber,
    required this.updatedAt,
    required this.createdAt,
  });

  factory Car.fromJson(Map<String, dynamic> json) => Car(
    id: json["id"],
    carname: json["carname"],
    ownername: json["ownername"],
    carNumber: json["carNumber"],
    transmissionType: json["transmissionType"],
    userId: json["userId"],
    username: json["username"],
    userNumber: json["userNumber"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "carname": carname,
    "ownername": ownername,
    "carNumber": carNumber,
    "transmissionType": transmissionType,
    "userId": userId,
    "username": username,
    "userNumber": userNumber,
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
  };
}
