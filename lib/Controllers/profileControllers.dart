import 'package:anaj_bazar/Constants/customNavigation.dart';
import 'package:anaj_bazar/Model/userdetails.dart';
import 'package:anaj_bazar/Services/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constants/customToast.dart';
import '../Screens/Auth/loginScreen.dart';

class ProfileController extends ChangeNotifier {
  bool _isToggleValue = true;
  bool get isToggleValue => _isToggleValue;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isWebviewLoading = false;
  bool get isWebviewLoading => _isWebviewLoading;

  UserDetailsModel? userDetailsModel;
  updateIsToggle(bool val) {
    _isToggleValue = val;
    notifyListeners();
  }

  updateIsWebView(bool val) {
    _isWebviewLoading = val;
    notifyListeners();
  }

  resetValues() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      notifyListeners();
    });
  }

  getUserDetails() async {
    _isLoading = true;
    await UsersService().getUserDetails().then((value) async {
      debugPrint(value.toString());
      userDetailsModel = value;
    })
        // .catchError((onError) {
        //   toast(text: 'Error Occured!!!');
        // })
        ;
    _isLoading = false;
    notifyListeners();
  }

  updateUserDetails(
      String firstName,
      String lastName,
      String emailId,
      String GSTNo,
      String tradeName,
      String fcmToken,
      int userId,
      context) async {
    var res = await UsersService().updateUserDetails(
        firstName, lastName, emailId, GSTNo, tradeName, fcmToken, userId);
    debugPrint(res.toString());

    if (res != null && res['Status'] == 1) {
      getUserDetails();
      Routes().backroute(context: context);
    } else {
      toast(text: res['Message']);
    }
    notifyListeners();
  }

  deleteUser(context) async {
    var userId = userDetailsModel?.user.userId ?? 0;
    var res = await UsersService().deleteUser(userId);
    debugPrint(res.toString());
    final SharedPreferences pref = await SharedPreferences.getInstance();
    if (res != null && res['Status'] == 1) {
      toast(text: res['Message']);
      pref.clear();
      Routes().pushroutewithremove(
          context: context, pages: LoginScreen(isLogin: true));
    } else {
      toast(text: res['Message']);
    }
    notifyListeners();
  }
}
