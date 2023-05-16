import 'dart:convert';

import 'package:anaj_bazar/Services/Apis.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthServices {
  signUp(String mobileNumber, bool isLogin) async {
    String jsonResponse;
    var currentUser;
    var value;
    var headers = {'Content-Type': 'application/json'};
    var endUrl = isLogin ? log_in_api : sign_up;
    var url = Anaj_Bazar + endUrl;

    debugPrint(url.toString());

    var request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "mobileNumber": mobileNumber,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    value = await response.stream.bytesToString();

    jsonResponse = value.toString();

    currentUser = json.decode(jsonResponse);
    return currentUser;
  }

  verifyotp(String mobileNumber, String otp, bool isLogin) async {
    String jsonResponse;
    var currentUser;
    var value;
    var headers = {'Content-Type': 'application/json'};
    var endPoint = isLogin ? log_in_api_otp_verify : sign_up_otp_verify;
    var url = Anaj_Bazar + endPoint;

    debugPrint(url.toString());

    var request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "mobileNumber": mobileNumber,
      "OTP": otp,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    value = await response.stream.bytesToString();

    jsonResponse = value.toString();

    currentUser = json.decode(jsonResponse);
    return currentUser;
  }

  createAccount({
    required String mobileNumber,
    required String firstName,
    required String lastName,
    String? GSTNo,
    String? tradeName,
    String? profilePic,
    String? fcmToken,
    String? emailId,
  }) async {
    String jsonResponse;
    var currentUser;
    var value;
    var headers = {'Content-Type': 'application/json'};
    var url = Anaj_Bazar + user_register;

    debugPrint(url.toString());

    var request = http.Request('POST', Uri.parse(url));
    request.body = json.encode({
      "mobileNumber": mobileNumber,
      "firstName": firstName,
      "lastName": lastName,
      "GSTNo": GSTNo,
      "tradeName": tradeName,
      "profilePic": profilePic,
      "fcmToken": fcmToken,
      "emailId": emailId,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    value = await response.stream.bytesToString();

    jsonResponse = value.toString();

    currentUser = json.decode(jsonResponse);
    return currentUser;
  }
}
