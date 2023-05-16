import 'dart:convert';

import 'package:anaj_bazar/Model/adressDetails.dart';
import 'package:anaj_bazar/Model/adresslist.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Apis.dart';

class LocationServices {
  addtoLocation(
      String address1,
      String address2,
      String landmark,
      String city,
      String state,
      String pincode,
      String addressAliasName,
      String name,
      String contactNumber,
      int isDefaultAddress,
      double lat,
      double long,
      int adressId,
      bool isFromEdit) async {
    String jsonResponse;
    String token;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('token')!;
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var endPoint =
        isFromEdit ? update_adress + adressId.toString() : add_address;
    var apiType = isFromEdit ? 'PUT' : 'POST';

    var url = Anaj_Bazar + endPoint;
    debugPrint(url.toString());
    var value;
    var currentUser;

    var request = http.Request(apiType, Uri.parse(url));
    request.body = json.encode({
      "address1": address1,
      "address2": address2,
      "landmark": landmark,
      "city": city,
      "state": state,
      "pincode": pincode,
      "addressAliasName": addressAliasName,
      "name": name,
      "contactNumber": contactNumber,
      "isDefaultAddress": isDefaultAddress,
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

  Future<AddressModel> getAdressList() async {
    var userDetails;
    String token;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('token')!;
    var headers = {'Authorization': 'Bearer $token'};

    var url = Anaj_Bazar + get_address;
    debugPrint(url.toString());

    try {
      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var value = await response.stream.bytesToString();

        var jsonMap = json.decode(value.toString());

        userDetails = AddressModel.fromJson(jsonMap);
      } else {}
    } catch (e) {
      return userDetails;
    }
    return userDetails;
  }

  Future<AddressDetailsModel> getAdressDetails(int id) async {
    var userDetails;
    String token;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('token')!;
    var headers = {'Authorization': 'Bearer $token'};

    var url = Anaj_Bazar + address_detailsbyId + id.toString();
    debugPrint(url.toString());

    try {
      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var value = await response.stream.bytesToString();

        var jsonMap = json.decode(value.toString());

        userDetails = AddressDetailsModel.fromJson(jsonMap);
      } else {}
    } catch (e) {
      return userDetails;
    }
    return userDetails;
  }

  deletecartItems(
    int addressId,
  ) async {
    String jsonResponse;
    String token;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('token')!;
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var url = Anaj_Bazar + delete_address + addressId.toString();
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
