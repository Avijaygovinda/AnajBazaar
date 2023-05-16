// To parse this JSON data, do
//
//     final homeTabModel = homeTabModelFromJson(jsonString);

import 'dart:convert';

HomeTabModel homeTabModelFromJson(String str) =>
    HomeTabModel.fromJson(json.decode(str));

String homeTabModelToJson(HomeTabModel data) => json.encode(data.toJson());

class HomeTabModel {
  HomeTabModel({
    required this.status,
    required this.banners,
    required this.categories,
    required this.topTrending,
    required this.dealsoftheday,
  });

  int status;
  List<Banner> banners;
  List<TopTrending> categories;
  List<TopTrending> topTrending;
  List<Dealsoftheday> dealsoftheday;

  factory HomeTabModel.fromJson(Map<String, dynamic> json) => HomeTabModel(
        status: json["Status"],
        banners:
            List<Banner>.from(json["banners"].map((x) => Banner.fromJson(x))),
        categories: List<TopTrending>.from(
            json["categories"].map((x) => TopTrending.fromJson(x))),
        topTrending: List<TopTrending>.from(
            json["TopTrending"].map((x) => TopTrending.fromJson(x))),
        dealsoftheday: List<Dealsoftheday>.from(
            json["dealsoftheday"].map((x) => Dealsoftheday.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "banners": List<dynamic>.from(banners.map((x) => x.toJson())),
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "TopTrending": List<dynamic>.from(topTrending.map((x) => x.toJson())),
        "dealsoftheday":
            List<dynamic>.from(dealsoftheday.map((x) => x.toJson())),
      };
}

class Banner {
  Banner({
    required this.bannerId,
    required this.bannerName,
    required this.imageUrl,
    required this.priority,
    required this.categoryId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.categoryName,
  });

  int bannerId;
  String bannerName;
  String imageUrl;
  int priority;
  int categoryId;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  String categoryName;

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
        bannerId: json["bannerId"],
        bannerName: json["bannerName"],
        imageUrl: json["imageUrl"],
        priority: json["priority"],
        categoryId: json["categoryId"],
        status: json["status"],
        categoryName: json["categoryName"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "bannerId": bannerId,
        "bannerName": bannerName,
        "imageUrl": imageUrl,
        "priority": priority,
        "categoryId": categoryId,
        "status": status,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

class TopTrending {
  TopTrending({
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

  factory TopTrending.fromJson(Map<String, dynamic> json) => TopTrending(
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

class Dealsoftheday {
  Dealsoftheday({
    required this.warehouseId,
    required this.productId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.variants,
    required this.categoryId,
    required this.productName,
    required this.imageUrl,
    required this.description,
    required this.hsNcode,
    required this.gst,
  });

  int warehouseId;
  int productId;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  List<Variant> variants;
  int categoryId;
  String productName;
  String imageUrl;
  String description;
  String hsNcode;
  double gst;

  factory Dealsoftheday.fromJson(Map<String, dynamic> json) => Dealsoftheday(
        warehouseId: json["warehouseId"],
        productId: json["productId"],
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        variants: List<Variant>.from(
            json["variants"].map((x) => Variant.fromJson(x))),
        categoryId: json["categoryId"],
        productName: json["productName"],
        imageUrl: json["imageUrl"],
        description: json["description"],
        hsNcode: json["HSNcode"],
        gst: json["gst"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "warehouseId": warehouseId,
        "productId": productId,
        "status": status,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "variants": List<dynamic>.from(variants.map((x) => x.toJson())),
        "categoryId": categoryId,
        "productName": productName,
        "imageUrl": imageUrl,
        "description": description,
        "HSNcode": hsNcode,
        "gst": gst,
      };
}

class Variant {
  Variant({
    required this.variantId,
    required this.productId,
    required this.metricValue,
    required this.metricType,
    required this.price,
    required this.sellingPrice,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.availableQty,
  });

  int variantId;
  int productId;
  String metricValue;
  String metricType;
  double price;
  double sellingPrice;
  int status;
  String createdAt;
  DateTime updatedAt;
  int availableQty;

  factory Variant.fromJson(Map<String, dynamic> json) => Variant(
        variantId: json["variantId"],
        productId: json["productId"],
        metricValue: json["metricValue"],
        metricType: json["metricType"],
        price: json["price"].toDouble(),
        sellingPrice: json["sellingPrice"].toDouble(),
        status: json["status"],
        createdAt: json["createdAt"],
        updatedAt: DateTime.parse(json["updatedAt"]),
        availableQty: json["availableQty"],
      );

  Map<String, dynamic> toJson() => {
        "variantId": variantId,
        "productId": productId,
        "metricValue": metricValue,
        "metricType": metricType,
        "price": price,
        "sellingPrice": sellingPrice,
        "status": status,
        "createdAt": createdAt,
        "updatedAt": updatedAt.toIso8601String(),
        "availableQty": availableQty,
      };
}
