import 'dart:convert';

import 'package:anaj_bazar/Model/userdetails.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Apis.dart';

class UsersService {
  Future<UserDetailsModel> getUserDetails() async {
    var userDetails;
    String token;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('token')!;
    var headers = {'Authorization': 'Bearer $token'};

    var url = Anaj_Bazar + user_details;
    debugPrint(url.toString());

    try {
      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var value = await response.stream.bytesToString();

        var jsonMap = json.decode(value.toString());

        userDetails = UserDetailsModel.fromJson(jsonMap);
      } else {}
    } catch (e) {
      return userDetails;
    }
    return userDetails;
  }

  updateUserDetails(String firstName, String lastName, String emailId,
      String GSTNo, String tradeName, String fcmToken, int userId) async {
    String jsonResponse;
    String token;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('token')!;
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var url = Anaj_Bazar + update_user;
    debugPrint(url.toString());
    var value;
    var currentUser;

    var request = http.Request('PUT', Uri.parse(url));
    request.body = json.encode({
      "firstName": firstName,
      "lastName": lastName,
      "emailId": emailId,
      "GSTNo": GSTNo,
      "tradeName": tradeName,
      "fcmToken": fcmToken,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    value = await response.stream.bytesToString();

    jsonResponse = value.toString();

    currentUser = json.decode(jsonResponse);
    return currentUser;
  }

  deleteUser(
    int userid,
  ) async {
    String jsonResponse;
    String token;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('token')!;
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var url = Anaj_Bazar + 'users/' + userid.toString() + delete_account;
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
