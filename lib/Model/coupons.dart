// To parse this JSON data, do
//
//     final couponsModel = couponsModelFromJson(jsonString);

import 'dart:convert';

CouponsModel couponsModelFromJson(String str) =>
    CouponsModel.fromJson(json.decode(str));

String couponsModelToJson(CouponsModel data) => json.encode(data.toJson());

class CouponsModel {
  CouponsModel({
    required this.status,
    required this.promoCodes,
  });

  int status;
  List<PromoCode> promoCodes;

  factory CouponsModel.fromJson(Map<String, dynamic> json) => CouponsModel(
        status: json["status"],
        promoCodes: List<PromoCode>.from(
            json["promoCodes"].map((x) => PromoCode.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "promoCodes": List<dynamic>.from(promoCodes.map((x) => x.toJson())),
      };
}

class PromoCode {
  PromoCode({
    required this.promoCodeId,
    required this.promoCode,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.offerValue,
    required this.maxDiscount,
    required this.minOrdervalue,
    required this.status,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });

  int promoCodeId;
  String promoCode;
  String description;
  DateTime startDate;
  DateTime endDate;
  int type;
  double offerValue;
  double maxDiscount;
  double minOrdervalue;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  String title;

  factory PromoCode.fromJson(Map<String, dynamic> json) => PromoCode(
        promoCodeId: json["promoCodeId"],
        promoCode: json["promoCode"],
        description: json["description"],
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        type: json["type"],
        offerValue: json["offerValue"].toDouble(),
        maxDiscount: json["maxDiscount"].toDouble(),
        minOrdervalue: json["minOrdervalue"].toDouble(),
        status: json["status"],
        title: json["title"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "promoCodeId": promoCodeId,
        "promoCode": promoCode,
        "description": description,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "type": type,
        "offerValue": offerValue,
        "maxDiscount": maxDiscount,
        "minOrdervalue": minOrdervalue,
        "status": status,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
