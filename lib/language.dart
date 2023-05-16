import 'package:anaj_bazar/Constants/customNavigation.dart';
import 'package:anaj_bazar/Screens/Intro/logo_Screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Model/languages/languages_list.dart';

class AppLanguage extends ChangeNotifier {
  Locale _appLocale = Locale('en');
  int selectedLanguage = 0;

  Locale get appLocal => _appLocale;

  fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    String languageCode = await prefs.getString('language_code') ?? '';

    if (languageCode == '' || languageCode == 'en') {
      _appLocale = Locale('en');
      selectedLanguage = 0;
    } else {
      _appLocale = Locale(languageCode);
      selectedLanguage = 1;
    }

    notifyListeners();
  }

  void changeLanguage(Locale type, bool isStarting, context) async {
    var prefs = await SharedPreferences.getInstance();
    isStarting
        ? Routes().pushroute(context: context, pages: LogoScreen())
        : Routes().backroute(context: context);
    if (_appLocale == type) {
      return;
    }
    for (var i = 0; i < LanguagesList.languages.length; i++) {
      if (type == Locale(LanguagesList.languages[i]['code']!)) {
        _appLocale = Locale(LanguagesList.languages[i]['code']!);
        await prefs.setString(
            'language_code', LanguagesList.languages[i]['code']!);
        break;
      }
      notifyListeners();
    }
    if (type == 'en') {
      selectedLanguage = 0;
    } else {
      selectedLanguage = 1;
    }

    notifyListeners();
  }
}
