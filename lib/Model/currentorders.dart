// To parse this JSON data, do
//
//     final currentOrdersModel = currentOrdersModelFromJson(jsonString);

import 'dart:convert';

CurrentOrdersModel currentOrdersModelFromJson(String str) =>
    CurrentOrdersModel.fromJson(json.decode(str));

String currentOrdersModelToJson(CurrentOrdersModel data) =>
    json.encode(data.toJson());

class CurrentOrdersModel {
  CurrentOrdersModel({
    required this.status,
    required this.orders,
  });

  int status;
  List<Order> orders;

  factory CurrentOrdersModel.fromJson(Map<String, dynamic> json) =>
      CurrentOrdersModel(
        status: json["Status"],
        orders: List<Order>.from(json["Orders"].map((x) => Order.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Orders": List<dynamic>.from(orders.map((x) => x.toJson())),
      };
}

class Order {
  Order({
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
    // required this.paymentdetails,
    // required this.orderdetails,
    required this.bankCharges,
    required this.createdAt,
    required this.updatedAt,
    required this.itemsCount,
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
  // String paymentdetails;
  // String orderdetails;
  double bankCharges;
  String createdAt;
  DateTime updatedAt;
  List<OrderItem> orderItems;
  int itemsCount;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
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
        // paymentdetails: json["paymentdetails"],
        // orderdetails: json["orderdetails"],
        bankCharges: json["bankCharges"].toDouble(),
        createdAt: json["createdAt"],
        updatedAt: DateTime.parse(json["updatedAt"]),
        orderItems: List<OrderItem>.from(
            json["OrderItems"].map((x) => OrderItem.fromJson(x))),
        itemsCount: json["ItemsCount"],
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
        // "paymentdetails": paymentdetails,
        // "orderdetails": orderdetails,
        "bankCharges": bankCharges,
        "createdAt": createdAt,
        "updatedAt": updatedAt.toIso8601String(),
      };
}

class OrderItem {
  OrderItem({
    required this.productName,
    required this.quantity,
  });
  String productName;
  int quantity;
  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        productName: json["productName"],
        quantity: json["quantity"],
      );
}
