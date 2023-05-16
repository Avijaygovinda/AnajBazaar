import 'dart:convert';

import 'package:anaj_bazar/Model/cartitems.dart';
import 'package:anaj_bazar/Model/categorybyid.dart';
import 'package:anaj_bazar/Model/minumumAmmount.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Apis.dart';

class ProductsServices {
  Future<CategoryByIdModel> getCategorybyIdData(
      int catID, int wherehouseId) async {
    var userDetails;
    String token;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('token')!;
    var headers = {'Authorization': 'Bearer $token'};

    var url = '$Anaj_Bazar$category_by_id$catID/$wherehouseId';
    debugPrint(url.toString());

    try {
      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var value = await response.stream.bytesToString();

        var jsonMap = json.decode(value.toString());

        userDetails = CategoryByIdModel.fromJson(jsonMap);
      } else {}
    } catch (e) {
      return userDetails;
    }
    return userDetails;
  }

  Future<CategoryByIdModel> getProductbyIdData(
      int catID, int wherehouseId) async {
    var userDetails;
    String token;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('token')!;
    var headers = {'Authorization': 'Bearer $token'};

    var url = '$Anaj_Bazar$product_by_id$catID/$wherehouseId';
    debugPrint(url.toString());

    try {
      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var value = await response.stream.bytesToString();

        var jsonMap = json.decode(value.toString());

        userDetails = CategoryByIdModel.fromJson(jsonMap);
      } else {}
    } catch (e) {
      return userDetails;
    }
    return userDetails;
  }

  Future<CartItemsModel> getCarts(int wherehouseId) async {
    var userDetails;
    String token;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('token')!;
    var headers = {'Authorization': 'Bearer $token'};

    var url = Anaj_Bazar + get_cart_list + wherehouseId.toString();
    debugPrint(url.toString());

    try {
      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var value = await response.stream.bytesToString();

        var jsonMap = json.decode(value.toString());

        userDetails = CartItemsModel.fromJson(jsonMap);
      } else {}
    } catch (e) {
      return userDetails;
    }
    return userDetails;
  }

  Future<CheckMinumumAmmount> checkMinumumAmmountFromapi() async {
    var userDetails;
    String token;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('token')!;
    var headers = {'Authorization': 'Bearer $token'};

    var url = Anaj_Bazar + check_minumum_amount;
    debugPrint(url.toString());

    try {
      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var value = await response.stream.bytesToString();

        var jsonMap = json.decode(value.toString());

        userDetails = CheckMinumumAmmount.fromJson(jsonMap);
      } else {}
    } catch (e) {
      return userDetails;
    }
    return userDetails;
  }

  addtoCart(
    int productId,
    int variantId,
    int quantity,
  ) async {
    String jsonResponse;
    String token;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('token')!;
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var url = Anaj_Bazar + add_to_cart;
    debugPrint(url.toString());
    var value;
    var currentUser;

    var request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "productId": productId,
      "variantId": variantId,
      "quantity": quantity,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    value = await response.stream.bytesToString();

    jsonResponse = value.toString();

    currentUser = json.decode(jsonResponse);
    return currentUser;
  }

  verifyPromo(String promoCode, double orderAmount) async {
    String jsonResponse;
    String token;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('token')!;
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var url = Anaj_Bazar + verify_promo;
    debugPrint(url.toString());
    var value;
    var currentUser;

    var request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "promoCode": promoCode,
      "orderAmount": orderAmount,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    value = await response.stream.bytesToString();

    jsonResponse = value.toString();

    currentUser = json.decode(jsonResponse);
    return currentUser;
  }

  createOrder(
    int cartId,
    int addressId,
    String name,
    String address1,
    String address2,
    String landmark,
    String city,
    String state,
    String pincode,
    String contactNumber,
    double latitude,
    double longitude,
    double discount,
    double subTotal,
    double promoAmount,
    double deliveryCharges,
    double grandTotal,
    String promocode,
    int paymentType,
    String emailId,
    String razorpayOrderId,
    int warehouseId,
    List OrderItems,
  ) async {
    String jsonResponse;
    String token;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('token')!;
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var url = Anaj_Bazar + create_orders;
    debugPrint(url.toString());
    var value;
    var currentUser;

    var request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "cartId": cartId,
      "addressId": addressId,
      "name": name,
      "address1": address1,
      "address2": address2,
      // "landmark": landmark,
      "city": city,
      "state": state,
      "pincode": pincode,
      "contactNumber": contactNumber,
      "latitude": latitude,
      "longitude": longitude,
      "discount": discount,
      "subTotal": subTotal,
      "promocode": promocode,
      "promoAmount": promoAmount,
      "deliveryCharges": deliveryCharges,
      "grandTotal": grandTotal,
      "paymentType": paymentType,
      "emailId": emailId,
      "warehouseId": warehouseId,
      "razorpayOrderId": razorpayOrderId,
      "OrderItems": OrderItems,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    value = await response.stream.bytesToString();

    jsonResponse = value.toString();

    currentUser = json.decode(jsonResponse);
    return currentUser;
  }

  deletecartItems(
    int productId,
    int variantId,
  ) async {
    String jsonResponse;
    String token;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('token')!;
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var url = '$Anaj_Bazar$delete_cart_item$productId/$variantId';
    debugPrint(url.toString());
    var value;
    var currentUser;

    var request = http.Request('DELETE', Uri.parse(url));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    value = await response.stream.bytesToString();

    jsonResponse = value.toString();

    currentUser = json.decode(jsonResponse);
    return currentUser;
  }

  deleteCart(int cartId) async {
    String jsonResponse;
    String token;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('token')!;
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var url = Anaj_Bazar + delete_cart + cartId.toString();
    debugPrint(url.toString());
    var value;
    var currentUser;

    var request = http.Request('DELETE', Uri.parse(url));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    value = await response.stream.bytesToString();

    jsonResponse = value.toString();

    currentUser = json.decode(jsonResponse);
    return currentUser;
  }
}
