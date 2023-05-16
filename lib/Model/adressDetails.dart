// To parse this JSON data, do
//
//     final addressDetailsModel = addressDetailsModelFromJson(jsonString);

import 'dart:convert';

AddressDetailsModel addressDetailsModelFromJson(String str) =>
    AddressDetailsModel.fromJson(json.decode(str));

String addressDetailsModelToJson(AddressDetailsModel data) =>
    json.encode(data.toJson());

class AddressDetailsModel {
  AddressDetailsModel({
    required this.status,
    required this.address,
  });

  int status;
  Address address;

  factory AddressDetailsModel.fromJson(Map<String, dynamic> json) =>
      AddressDetailsModel(
        status: json["Status"],
        address: Address.fromJson(json["Address"]),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Address": address.toJson(),
      };
}

class Address {
  Address({
    required this.userAddressId,
    required this.userId,
    required this.address1,
    required this.address2,
    required this.landmark,
    required this.pincode,
    required this.city,
    required this.state,
    required this.name,
    required this.contactNumber,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
  });

  int userAddressId;
  int userId;
  String address1;
  String address2;
  String landmark;
  String pincode;
  String city;
  String state;
  String name;
  String contactNumber;
  int status;
  double latitude;
  double longitude;
  DateTime createdAt;
  DateTime updatedAt;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        userAddressId: json["userAddressId"],
        userId: json["userId"],
        address1: json["address1"],
        address2: json["address2"],
        landmark: json["landmark"],
        pincode: json["pincode"],
        city: json["city"],
        state: json["state"],
        name: json["name"],
        contactNumber: json["contactNumber"],
        status: json["status"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "userAddressId": userAddressId,
        "userId": userId,
        "address1": address1,
        "address2": address2,
        "landmark": landmark,
        "pincode": pincode,
        "city": city,
        "state": state,
        "name": name,
        "contactNumber": contactNumber,
        "status": status,
        "latitude": latitude,
        "longitude": longitude,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
