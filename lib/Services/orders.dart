import 'dart:convert';

import 'package:anaj_bazar/Model/currentorders.dart';
import 'package:anaj_bazar/Model/orderDetails.dart';
import 'package:anaj_bazar/Services/Apis.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrdersService {
  Future<CurrentOrdersModel> getcurrentOrders(bool isCurrent) async {
    var userDetails;
    String token;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('token')!;
    var headers = {'Authorization': 'Bearer $token'};
    var endPointurl = isCurrent ? current_orders : past_orders;
    var url = Anaj_Bazar + endPointurl;
    debugPrint(url.toString());

    try {
      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var value = await response.stream.bytesToString();

        var jsonMap = json.decode(value.toString());

        userDetails = CurrentOrdersModel.fromJson(jsonMap);
      } else {}
    } catch (e) {
      return userDetails;
    }
    return userDetails;
  }

  Future<OrderDetailsModel> getOrderDetails(int orderId) async {
    var userDetails;
    String token;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('token')!;
    var headers = {'Authorization': 'Bearer $token'};
    var url = Anaj_Bazar + orders_details + orderId.toString();
    debugPrint(url.toString());

    try {
      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var value = await response.stream.bytesToString();

        var jsonMap = json.decode(value.toString());

        userDetails = OrderDetailsModel.fromJson(jsonMap);
      } else {}
    } catch (e) {
      return userDetails;
    }
    return userDetails;
  }

  reOrders(
    int orderId,
    int warehouseId,
  ) async {
    String jsonResponse;
    String token;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('token')!;
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var url = Anaj_Bazar + re_orders;
    debugPrint(url.toString());
    var value;
    var currentUser;

    var request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "orderId": orderId,
      "warehouseId": warehouseId,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    value = await response.stream.bytesToString();

    jsonResponse = value.toString();

    currentUser = json.decode(jsonResponse);
    return currentUser;
  }

  orderPayment(
    double orderAmount,
  ) async {
    String jsonResponse;
    String token;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('token')!;
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var url = Anaj_Bazar + order_payment;
    debugPrint(url.toString());
    var value;
    var currentUser;

    var request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "orderAmount": orderAmount,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    value = await response.stream.bytesToString();

    jsonResponse = value.toString();

    currentUser = json.decode(jsonResponse);
    return currentUser;
  }

  cacnelOrder(
    int orderId,
    String reason,
  ) async {
    String jsonResponse;
    String token;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('token')!;
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var url = Anaj_Bazar + cancel_orders + orderId.toString();
    debugPrint(url.toString());
    var value;
    var currentUser;

    var request = http.Request('PUT', Uri.parse(url));
    request.body = json.encode({
      "cancellationReason": reason,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    value = await response.stream.bytesToString();

    jsonResponse = value.toString();

    currentUser = json.decode(jsonResponse);
    return currentUser;
  }
}
