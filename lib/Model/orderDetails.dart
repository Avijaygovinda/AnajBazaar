// To parse this JSON data, do
//
//     final orderDetailsModel = orderDetailsModelFromJson(jsonString);

import 'dart:convert';

OrderDetailsModel orderDetailsModelFromJson(String str) =>
    OrderDetailsModel.fromJson(json.decode(str));

String orderDetailsModelToJson(OrderDetailsModel data) =>
    json.encode(data.toJson());

class OrderDetailsModel {
  OrderDetailsModel({
    required this.status,
    required this.orders,
  });

  int status;
  Orders orders;

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailsModel(
        status: json["Status"],
        orders: Orders.fromJson(json["Orders"]),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Orders": orders.toJson(),
      };
}

class Orders {
  Orders({
    required this.orderId,
    required this.userId,
    required this.cartId,
    required this.addressId,
    required this.name,
    required this.address1,
    required this.address2,
    required this.landmark,
    required this.city,
    required this.state,
    required this.pincode,
    required this.contactNumber,
    required this.discount,
    required this.subTotal,
    required this.promocode,
    required this.promoAmount,
    required this.deliveryCharges,
    required this.grandTotal,
    required this.paymentType,
    required this.orderStatus,
    required this.razorpayOrderId,
    required this.transactionId,
    required this.paymentStatus,
    required this.expectedDelivery,
    required this.deliveredDateTime,
    required this.deliveryBoyId,
    required this.cancellationReason,
    required this.emailId,
    required this.warehouseId,
    required this.invoiceFile,
    required this.flag,
    required this.codCharges,
    required this.latitude,
    required this.longitude,
    required this.paymentdetails,
    required this.orderdetails,
    required this.bankCharges,
    required this.createdAt,
    required this.updatedAt,
    required this.orderItems,
  });

  int orderId;
  int userId;
  int cartId;
  int addressId;
  String name;
  String address1;
  String address2;
  String landmark;
  String city;
  String state;
  String pincode;
  String contactNumber;
  double discount;
  double subTotal;
  String promocode;
  double promoAmount;
  double deliveryCharges;
  double grandTotal;
  int paymentType;
  int orderStatus;
  String razorpayOrderId;
  String transactionId;
  int paymentStatus;
  String expectedDelivery;
  String deliveredDateTime;
  int deliveryBoyId;
  String cancellationReason;
  String emailId;
  int warehouseId;
  String invoiceFile;
  int flag;
  double codCharges;
  double latitude;
  double longitude;
  Details paymentdetails;
  Details orderdetails;
  double bankCharges;
  String createdAt;
  DateTime updatedAt;
  List<OrderItem> orderItems;

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
        orderId: json["orderId"],
        userId: json["userId"],
        cartId: json["cartId"],
        addressId: json["addressId"],
        name: json["name"],
        address1: json["address1"],
        address2: json["address2"],
        landmark: json["landmark"],
        city: json["city"],
        state: json["state"],
        pincode: json["pincode"],
        contactNumber: json["contactNumber"],
        discount: json["discount"].toDouble(),
        subTotal: json["subTotal"].toDouble(),
        promocode: json["promocode"],
        promoAmount: json["promoAmount"].toDouble(),
        deliveryCharges: json["deliveryCharges"].toDouble(),
        grandTotal: json["grandTotal"].toDouble(),
        paymentType: json["paymentType"],
        orderStatus: json["orderStatus"],
        razorpayOrderId: json["razorpayOrderId"],
        transactionId: json["transactionId"],
        paymentStatus: json["paymentStatus"],
        expectedDelivery: json["expectedDelivery"],
        deliveredDateTime: json["deliveredDateTime"],
        deliveryBoyId: json["deliveryBoyId"],
        cancellationReason: json["cancellationReason"],
        emailId: json["emailId"],
        warehouseId: json["warehouseId"],
        invoiceFile: json["invoiceFile"],
        flag: json["flag"],
        codCharges: json["codCharges"].toDouble(),
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        paymentdetails: Details.fromJson(json["paymentdetails"]),
        orderdetails: Details.fromJson(json["orderdetails"]),
        bankCharges: json["bankCharges"].toDouble(),
        createdAt: json["createdAt"],
        updatedAt: DateTime.parse(json["updatedAt"]),
        orderItems: List<OrderItem>.from(
            json["OrderItems"].map((x) => OrderItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "userId": userId,
        "cartId": cartId,
        "addressId": addressId,
        "name": name,
        "address1": address1,
        "address2": address2,
        "landmark": landmark,
        "city": city,
        "state": state,
        "pincode": pincode,
        "contactNumber": contactNumber,
        "discount": discount,
        "subTotal": subTotal,
        "promocode": promocode,
        "promoAmount": promoAmount,
        "deliveryCharges": deliveryCharges,
        "grandTotal": grandTotal,
        "paymentType": paymentType,
        "orderStatus": orderStatus,
        "razorpayOrderId": razorpayOrderId,
        "transactionId": transactionId,
        "paymentStatus": paymentStatus,
        "expectedDelivery": expectedDelivery,
        "deliveredDateTime": deliveredDateTime,
        "deliveryBoyId": deliveryBoyId,
        "cancellationReason": cancellationReason,
        "emailId": emailId,
        "warehouseId": warehouseId,
        "invoiceFile": invoiceFile,
        "flag": flag,
        "codCharges": codCharges,
        "latitude": latitude,
        "longitude": longitude,
        "paymentdetails": paymentdetails.toJson(),
        "orderdetails": orderdetails.toJson(),
        "bankCharges": bankCharges,
        "createdAt": createdAt,
        "updatedAt": updatedAt.toIso8601String(),
        "OrderItems": List<dynamic>.from(orderItems.map((x) => x.toJson())),
      };
}

class OrderItem {
  OrderItem({
    required this.itemId,
    required this.orderId,
    required this.productId,
    required this.categoryId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.sellingPrice,
    required this.gst,
    required this.totalAmount,
    required this.imageUrl,
    required this.hsNcode,
    required this.variantId,
    required this.metricValue,
    required this.metricType,
    required this.createdAt,
    required this.updatedAt,
  });

  int itemId;
  int orderId;
  int productId;
  int categoryId;
  String productName;
  int quantity;
  double price;
  double sellingPrice;
  double gst;
  double totalAmount;
  String imageUrl;
  String hsNcode;
  String variantId;
  String metricValue;
  String metricType;
  DateTime createdAt;
  DateTime updatedAt;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        itemId: json["itemId"],
        orderId: json["orderId"],
        productId: json["productId"],
        categoryId: json["categoryId"],
        productName: json["productName"],
        quantity: json["quantity"],
        price: json["price"].toDouble(),
        sellingPrice: json["sellingPrice"].toDouble(),
        gst: json["gst"].toDouble(),
        totalAmount: json["totalAmount"].toDouble(),
        imageUrl: json["imageUrl"],
        hsNcode: json["HSNcode"],
        variantId: json["variantId"],
        metricValue: json["metricValue"],
        metricType: json["metricType"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "itemId": itemId,
        "orderId": orderId,
        "productId": productId,
        "categoryId": categoryId,
        "productName": productName,
        "quantity": quantity,
        "price": price,
        "sellingPrice": sellingPrice,
        "gst": gst,
        "totalAmount": totalAmount,
        "imageUrl": imageUrl,
        "HSNcode": hsNcode,
        "variantId": variantId,
        "metricValue": metricValue,
        "metricType": metricType,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

class Details {
  Details();

  factory Details.fromJson(Map<String, dynamic> json) => Details();

  Map<String, dynamic> toJson() => {};
}
