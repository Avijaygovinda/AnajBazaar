// To parse this JSON data, do
//
//     final userDetailsModel = userDetailsModelFromJson(jsonString);

import 'dart:convert';

UserDetailsModel userDetailsModelFromJson(String str) =>
    UserDetailsModel.fromJson(json.decode(str));

String userDetailsModelToJson(UserDetailsModel data) =>
    json.encode(data.toJson());

class UserDetailsModel {
  UserDetailsModel({
    required this.status,
    required this.user,
  });

  int status;
  User user;

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) =>
      UserDetailsModel(
        status: json["Status"],
        user: User.fromJson(json["User"]),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "User": user.toJson(),
      };
}

class User {
  User({
    required this.userId,
    required this.mobileNumber,
    required this.firstName,
    required this.lastName,
    required this.otp,
    required this.emailId,
    required this.profilePic,
    required this.gstNo,
    required this.userStatus,
    required this.fcmToken,
    required this.tradeName,
    required this.createdAt,
    required this.updatedAt,
  });

  int userId;
  String mobileNumber;
  String firstName;
  String lastName;
  String otp;
  String emailId;
  String profilePic;
  String gstNo;
  int userStatus;
  String fcmToken;
  String tradeName;
  DateTime createdAt;
  DateTime updatedAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["userId"],
        mobileNumber: json["mobileNumber"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        otp: json["OTP"],
        emailId: json["emailId"],
        profilePic: json["profilePic"],
        gstNo: json["GSTNo"],
        userStatus: json["userStatus"],
        fcmToken: json["fcmToken"],
        tradeName: json["tradeName"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "mobileNumber": mobileNumber,
        "firstName": firstName,
        "lastName": lastName,
        "OTP": otp,
        "emailId": emailId,
        "profilePic": profilePic,
        "GSTNo": gstNo,
        "userStatus": userStatus,
        "fcmToken": fcmToken,
        "tradeName": tradeName,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
