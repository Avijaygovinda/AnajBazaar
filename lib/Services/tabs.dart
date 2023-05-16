import 'dart:convert';
import 'package:anaj_bazar/Model/categoryTab.dart';
import 'package:anaj_bazar/Model/coupons.dart';
import 'package:anaj_bazar/Model/notifications.dart';
import 'package:anaj_bazar/Services/Apis.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:anaj_bazar/Model/homeTab.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabsServices {
  Future<HomeTabModel> getHomeTabData(int whereHouse) async {
    var userDetails;
    String token;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('token')!;
    var headers = {'Authorization': 'Bearer $token'};

    var url = Anaj_Bazar + home_tabs + whereHouse.toString();
    debugPrint(url.toString());

    try {
      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var value = await response.stream.bytesToString();

        var jsonMap = json.decode(value.toString());

        userDetails = HomeTabModel.fromJson(jsonMap);
      } else {}
    } catch (e) {
      return userDetails;
    }
    return userDetails;
  }

  Future<CategoryTabModel> getCategoryTabData() async {
    var userDetails;
    String token;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('token')!;
    var headers = {'Authorization': 'Bearer $token'};

    var url = Anaj_Bazar + category_tabs;
    debugPrint(url.toString());

    try {
      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var value = await response.stream.bytesToString();

        var jsonMap = json.decode(value.toString());

        userDetails = CategoryTabModel.fromJson(jsonMap);
      } else {}
    } catch (e) {
      return userDetails;
    }
    return userDetails;
  }

  Future<NotificationsModel> getNotificationsTabData() async {
    var userDetails;
    String token;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('token')!;
    var headers = {'Authorization': 'Bearer $token'};

    var url = Anaj_Bazar + notifications_list;
    debugPrint(url.toString());

    try {
      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var value = await response.stream.bytesToString();

        var jsonMap = json.decode(value.toString());

        userDetails = NotificationsModel.fromJson(jsonMap);
      } else {}
    } catch (e) {
      return userDetails;
    }
    return userDetails;
  }

  Future<CouponsModel> getCouponsTabData() async {
    var userDetails;
    String token;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('token')!;
    var headers = {'Authorization': 'Bearer $token'};

    var url = Anaj_Bazar + coupons_list;
    debugPrint(url.toString());

    try {
      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var value = await response.stream.bytesToString();

        var jsonMap = json.decode(value.toString());

        userDetails = CouponsModel.fromJson(jsonMap);
      } else {}
    } catch (e) {
      return userDetails;
    }
    return userDetails;
  }

  sendWherehouse(double lat, double long) async {
    String jsonResponse;
    String token;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('token')!;
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var url = Anaj_Bazar + send_wherehouse;
    debugPrint(url.toString());
    var value;
    var currentUser;

    var request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "latitude": lat,
      "longitude": long,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    value = await response.stream.bytesToString();

    jsonResponse = value.toString();

    currentUser = json.decode(jsonResponse);
    return currentUser;
  }

  searchProducts(String warehouseId, String productName) async {
    String jsonResponse;
    String token;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('token')!;
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var url = Anaj_Bazar + search_products;
    debugPrint(url.toString());
    var value;
    var currentUser;

    var request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "warehouseId": warehouseId,
      "productName": productName,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    value = await response.stream.bytesToString();

    jsonResponse = value.toString();

    currentUser = json.decode(jsonResponse);
    return currentUser;
  }

  deleteNotifications() async {
    String jsonResponse;
    String token;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('token')!;
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var url = Anaj_Bazar + clear_notifications;
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
