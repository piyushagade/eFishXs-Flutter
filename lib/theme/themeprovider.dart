import 'package:flutter/material.dart';
import 'package:efishxs/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = darkmode;
  ThemeData get themeData => _themeData;
  bool get isdarkmode => _themeData == darkmode;

  set themeData (ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggletheme () {
    if (_themeData == lightmode) {
      themeData = darkmode;
    } else {
      themeData = lightmode;
    }
  }
}