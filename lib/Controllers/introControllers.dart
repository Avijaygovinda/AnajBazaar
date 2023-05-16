import 'package:flutter/material.dart';

class IntroControllers extends ChangeNotifier {
  int _sliderIndex = 0;
  int get sliderIndex => _sliderIndex;

  updateSliderIndex(int val) {
    _sliderIndex = val;
    notifyListeners();
  }

  resetSliderindex() {
    _sliderIndex = 0;
  }
}
