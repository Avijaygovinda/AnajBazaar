// To parse this JSON data, do
//
//     final cartItemsModel = cartItemsModelFromJson(jsonString);

import 'dart:convert';

CartItemsModel cartItemsModelFromJson(String str) =>
    CartItemsModel.fromJson(json.decode(str));

String cartItemsModelToJson(CartItemsModel data) => json.encode(data.toJson());

class CartItemsModel {
  CartItemsModel({
    required this.status,
    required this.cart,
  });

  int status;
  List<Cart> cart;

  factory CartItemsModel.fromJson(Map<String, dynamic> json) => CartItemsModel(
        status: json["Status"],
        cart: List<Cart>.from(json["Cart"].map((x) => Cart.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Cart": List<dynamic>.from(cart.map((x) => x.toJson())),
      };
}

class Cart {
  Cart({
    required this.cartId,
    required this.userId,
    required this.isOrderLinked,
    required this.createdat,
    required this.updatedAt,
    required this.cartItems,
  });

  int cartId;
  String userId;
  String isOrderLinked;
  DateTime createdat;
  DateTime updatedAt;
  List<CartItem> cartItems;

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        cartId: json["cartId"],
        userId: json["userId"],
        isOrderLinked: json["isOrderLinked"],
        createdat: DateTime.parse(json["createdat"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        cartItems: List<CartItem>.from(
            json["cartItems"].map((x) => CartItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "cartId": cartId,
        "userId": userId,
        "isOrderLinked": isOrderLinked,
        "createdat": createdat.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "cartItems": List<dynamic>.from(cartItems.map((x) => x.toJson())),
      };
}

class CartItem {
  CartItem({
    required this.warehouseId,
    required this.variants,
    required this.productId,
    required this.categoryId,
    required this.productName,
    required this.imageUrl,
    required this.description,
    required this.status,
    required this.hsNcode,
    required this.gst,
    required this.createdAt,
    required this.updatedAt,
    required this.cartId,
    required this.quantity,
    required this.cartItemId,
    required this.variantId,
    required this.metricValue,
    required this.metricType,
    required this.price,
    required this.sellingPrice,
    required this.availableQty,
  });

  int warehouseId;
  String variants;
  int productId;
  int categoryId;
  String productName;
  String imageUrl;
  String description;
  int status;
  String hsNcode;
  double gst;
  DateTime createdAt;
  DateTime updatedAt;
  int cartId;
  int quantity;
  int cartItemId;
  int variantId;
  String metricValue;
  String metricType;
  double price;
  double sellingPrice;
  int availableQty;

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        warehouseId: json["warehouseId"],
        variants: json["variants"],
        productId: json["productId"],
        categoryId: json["categoryId"],
        productName: json["productName"],
        imageUrl: json["imageUrl"],
        description: json["description"],
        status: json["status"],
        hsNcode: json["HSNcode"],
        gst: json["gst"].toDouble(),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        cartId: json["cartId"],
        quantity: json["quantity"],
        cartItemId: json["CartItemId"],
        variantId: json["variantId"],
        metricValue: json["metricValue"],
        metricType: json["metricType"],
        availableQty: json["availableQty"],
        price: json["price"].toDouble(),
        sellingPrice: json["sellingPrice"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "warehouseId": warehouseId,
        "variants": variants,
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
        "cartId": cartId,
        "quantity": quantity,
        "CartItemId": cartItemId,
        "variantId": variantId,
        "metricValue": metricValue,
        "metricType": metricType,
        "price": price,
        "sellingPrice": sellingPrice,
      };
}

// // To parse this JSON data, do
// //
// //     final cartItemsModel = cartItemsModelFromJson(jsonString);

// import 'package:meta/meta.dart';
// import 'dart:convert';

// CartItemsModel cartItemsModelFromJson(String str) =>
//     CartItemsModel.fromJson(json.decode(str));

// String cartItemsModelToJson(CartItemsModel data) => json.encode(data.toJson());

// class CartItemsModel {
//   CartItemsModel({
//     required this.status,
//     required this.cart,
//   });

//   int status;
//   List<Cart> cart;

//   factory CartItemsModel.fromJson(Map<String, dynamic> json) => CartItemsModel(
//         status: json["Status"],
//         cart: List<Cart>.from(json["Cart"].map((x) => Cart.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "Status": status,
//         "Cart": List<dynamic>.from(cart.map((x) => x.toJson())),
//       };
// }

// class Cart {
//   Cart({
//     required this.cartId,
//     required this.userId,
//     required this.isOrderLinked,
//     required this.createdat,
//     required this.updatedAt,
//     required this.cartItems,
//   });

//   int cartId;
//   String userId;
//   String isOrderLinked;
//   DateTime createdat;
//   DateTime updatedAt;
//   List<CartItem> cartItems;

//   factory Cart.fromJson(Map<String, dynamic> json) => Cart(
//         cartId: json["cartId"],
//         userId: json["userId"],
//         isOrderLinked: json["isOrderLinked"],
//         createdat: DateTime.parse(json["createdat"]),
//         updatedAt: DateTime.parse(json["updatedAt"]),
//         cartItems: List<CartItem>.from(
//             json["cartItems"].map((x) => CartItem.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "cartId": cartId,
//         "userId": userId,
//         "isOrderLinked": isOrderLinked,
//         "createdat": createdat.toIso8601String(),
//         "updatedAt": updatedAt.toIso8601String(),
//         "cartItems": List<dynamic>.from(cartItems.map((x) => x.toJson())),
//       };
// }

// class CartItem {
//   CartItem({
//     required this.warehouseId,
//     required this.variants,
//     required this.productId,
//     required this.categoryId,
//     required this.productName,
//     required this.imageUrl,
//     required this.description,
//     required this.status,
//     required this.hsNcode,
//     required this.gst,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.cartId,
//     required this.quantity,
//     required this.cartItemId,
//     required this.variantId,
//     required this.metricValue,
//     required this.metricType,
//     required this.price,
//     required this.sellingPrice,
//     required this.paymentdetails,
//     required this.orderdetails,
//     required this.bankCharges,
//     required this.availableQty,
//   });

//   int warehouseId;
//   String variants;
//   int productId;
//   int categoryId;
//   String productName;
//   String imageUrl;
//   String description;
//   int status;
//   String hsNcode;
//   double gst;
//   String createdAt;
//   DateTime updatedAt;
//   int cartId;
//   int quantity;
//   int cartItemId;
//   int variantId;
//   String metricValue;
//   String metricType;
//   double price;
//   double sellingPrice;
//   dynamic paymentdetails;
//   dynamic orderdetails;
//   double bankCharges;
//   int availableQty;

//   factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
//         warehouseId: json["warehouseId"],
//         variants: json["variants"],
//         productId: json["productId"],
//         categoryId: json["categoryId"],
//         productName: json["productName"],
//         imageUrl: json["imageUrl"],
//         description: json["description"],
//         status: json["status"],
//         hsNcode: json["HSNcode"],
//         gst: json["gst"].toDouble(),
//         createdAt: json["createdAt"],
//         updatedAt: DateTime.parse(json["updatedAt"]),
//         cartId: json["cartId"],
//         quantity: json["quantity"],
//         cartItemId: json["CartItemId"],
//         variantId: json["variantId"],
//         metricValue: json["metricValue"],
//         metricType: json["metricType"],
//         price: json["price"].toDouble(),
//         sellingPrice: json["sellingPrice"].toDouble(),
//         paymentdetails: json["paymentdetails"],
//         orderdetails: json["orderdetails"],
//         bankCharges: json["bankCharges"].toDouble(),
//         availableQty: json["availableQty"],
//       );

//   Map<String, dynamic> toJson() => {
//         "warehouseId": warehouseId,
//         "variants": variants,
//         "productId": productId,
//         "categoryId": categoryId,
//         "productName": productName,
//         "imageUrl": imageUrl,
//         "description": description,
//         "status": status,
//         "HSNcode": hsNcode,
//         "gst": gst,
//         "createdAt": createdAt,
//         "updatedAt": updatedAt.toIso8601String(),
//         "cartId": cartId,
//         "quantity": quantity,
//         "CartItemId": cartItemId,
//         "variantId": variantId,
//         "metricValue": metricValue,
//         "metricType": metricType,
//         "price": price,
//         "sellingPrice": sellingPrice,
//         "paymentdetails": paymentdetails,
//         "orderdetails": orderdetails,
//         "bankCharges": bankCharges,
//         "availableQty": availableQty,
//       };
// }
