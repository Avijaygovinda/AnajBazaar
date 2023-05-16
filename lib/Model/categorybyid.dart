// To parse this JSON data, do
//
//     final categoryByIdModel = categoryByIdModelFromJson(jsonString);

import 'dart:convert';

CategoryByIdModel categoryByIdModelFromJson(String str) =>
    CategoryByIdModel.fromJson(json.decode(str));

String categoryByIdModelToJson(CategoryByIdModel data) =>
    json.encode(data.toJson());

class CategoryByIdModel {
  CategoryByIdModel({
    required this.status,
    required this.products,
  });

  int status;
  List<Product> products;

  factory CategoryByIdModel.fromJson(Map<String, dynamic> json) =>
      CategoryByIdModel(
        status: json["Status"],
        products: List<Product>.from(
            json["Products"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class Product {
  Product({
    required this.productId,
    required this.categoryId,
    required this.productName,
    required this.imageUrl,
    required this.description,
    required this.status,
    required this.hsNcode,
    required this.gst,
    required this.quantityIncart,
    required this.variantIncart,
    required this.createdAt,
    required this.updatedAt,
    required this.variants,
  });

  int productId;
  int categoryId;
  String productName;
  String imageUrl;
  String description;
  int status;
  int quantityIncart;
  int variantIncart;
  String hsNcode;
  double gst;
  DateTime createdAt;
  DateTime updatedAt;
  List<Variant> variants;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productId: json["productId"],
        categoryId: json["categoryId"],
        productName: json["productName"],
        imageUrl: json["imageUrl"],
        description: json["description"],
        status: json["status"],
        hsNcode: json["HSNcode"],
        quantityIncart: json["quantityIncart"],
        variantIncart: json["variantIncart"],
        gst: json["gst"].toDouble(),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        variants: List<Variant>.from(
            json["variants"].map((x) => Variant.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "categoryId": categoryId,
        "productName": productName,
        "imageUrl": imageUrl,
        "description": description,
        "status": status,
        "HSNcode": hsNcode,
        "gst": gst,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "variants": List<dynamic>.from(variants.map((x) => x.toJson())),
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
