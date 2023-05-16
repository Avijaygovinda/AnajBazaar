// To parse this JSON data, do
//
//     final categoryTabModel = categoryTabModelFromJson(jsonString);

import 'dart:convert';

CategoryTabModel categoryTabModelFromJson(String str) =>
    CategoryTabModel.fromJson(json.decode(str));

String categoryTabModelToJson(CategoryTabModel data) =>
    json.encode(data.toJson());

class CategoryTabModel {
  CategoryTabModel({
    required this.status,
    required this.categories,
  });

  int status;
  List<Category> categories;

  factory CategoryTabModel.fromJson(Map<String, dynamic> json) =>
      CategoryTabModel(
        status: json["Status"],
        categories: List<Category>.from(
            json["categories"].map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
      };
}

class Category {
  Category({
    required this.categoryId,
    required this.categoryName,
    required this.imageUrl,
    required this.priority,
    required this.status,
    required this.metaTitle,
    required this.metaDescription,
    required this.metaKeywords,
    required this.createdAt,
    required this.updatedAt,
  });

  int categoryId;
  String categoryName;
  String imageUrl;
  int priority;
  int status;
  String metaTitle;
  String metaDescription;
  String metaKeywords;
  DateTime createdAt;
  DateTime updatedAt;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        categoryId: json["categoryId"],
        categoryName: json["categoryName"],
        imageUrl: json["imageUrl"],
        priority: json["priority"],
        status: json["status"],
        metaTitle: json["metaTitle"],
        metaDescription: json["metaDescription"],
        metaKeywords: json["metaKeywords"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["UpdatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "categoryId": categoryId,
        "categoryName": categoryName,
        "imageUrl": imageUrl,
        "priority": priority,
        "status": status,
        "metaTitle": metaTitle,
        "metaDescription": metaDescription,
        "metaKeywords": metaKeywords,
        "createdAt": createdAt.toIso8601String(),
        "UpdatedAt": updatedAt.toIso8601String(),
      };
}
