import 'dart:async';

import 'package:anaj_bazar/Screens/Home/tabs.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constants/customNavigation.dart';
import '../Constants/customToast.dart';
import '../Screens/Auth/createAcountScreen.dart';
import '../Screens/Auth/otpScreen.dart';
import '../Services/auth.dart';

class AuthControllers extends ChangeNotifier {
  int _timers = 10;
  bool resendotp = false;

  String _checkLoggedorNot = '';
  String get checkLoggedorNot => _checkLoggedorNot;

  int time() => _timers;
  Timer? timer;
  void setTimer() {
    resendotp = true;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timers > 0) {
        _timers--;
      } else {
        timer.cancel();
        resendotp = false;
        if (resendotp == false) {
          _timers = 10;
        }
      }
      notifyListeners();
    });

    notifyListeners();
  }

  disposeTimer() {
    _timers = 10;
    timer?.cancel();

    notifyListeners();
  }

  signupsendOtp(
      String mobileNumber, bool isResed, bool isLogin, context) async {
    easyLoading(context: context);
    var res = await AuthServices().signUp(mobileNumber, isLogin);
    debugPrint(res.toString());
    if (res != null && res['Status'] == 1) {
      dismissLoading();
      await toast(text: res['Message']);
      isResed
          ? null
          : Routes().pushroute(
              context: context,
              pages: OTPScreen(
                isLogin: isLogin,
                mobileNumber: mobileNumber,
              ));
    } else {
      dismissLoading();
      toast(text: res['Message']);
    }
    notifyListeners();
  }

  signupverifyOtp(
      String mobileNumber, String otp, bool isLogin, context) async {
    if (otp.isNotEmpty) {
      if (otp.length >= 4) {
        final SharedPreferences pref = await SharedPreferences.getInstance();
        easyLoading(context: context);
        ;
        var res = await AuthServices().verifyotp(mobileNumber, otp, isLogin);
        debugPrint(res.toString());
        if (res != null && res['Status'] == 1) {
          dismissLoading();
          await toast(text: res['Message']);
          if (isLogin) {
            pref.setString('token', res['Token']);

            Routes().pushroute(context: context, pages: HomeScreenTabs());
          } else {
            Routes().pushroute(
                context: context,
                pages: CreateAccountScreen(
                  mobileNumber: mobileNumber,
                ));
          }
        } else {
          dismissLoading();
          toast(text: res['Message']);
        }
      } else {
        toast(text: 'Invalid OTP');
      }
    } else {
      toast(text: 'Please Enter OTP');
    }

    notifyListeners();
  }

  createAccount(
      {required String mobileNumber,
      required String firstName,
      required String lastName,
      String? GSTNo,
      String? tradeName,
      String? profilePic,
      required String fcmToken,
      String? emailId,
      context}) async {
    easyLoading(context: context);
    ;
    var res = await AuthServices().createAccount(
      mobileNumber: mobileNumber,
      firstName: firstName,
      lastName: lastName,
      GSTNo: GSTNo,
      emailId: emailId,
      fcmToken: fcmToken,
      profilePic: profilePic,
      tradeName: tradeName,
    );
    debugPrint('fcmToken : $fcmToken'.toString());
    debugPrint(res.toString());
    if (res != null && res['Status'] == 1) {
      dismissLoading();
      final SharedPreferences pref = await SharedPreferences.getInstance();

      pref.setString('token', res['Token']);
      toast(text: res['Message']);
      Routes().pushroute(context: context, pages: HomeScreenTabs());
    } else {
      dismissLoading();
      toast(text: res['Message']);
    }
    notifyListeners();
  }
}
