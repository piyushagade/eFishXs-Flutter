import 'package:flutter/material.dart';
import 'package:efishxs/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = darkgreymode;
  ThemeData get themeData => _themeData;
  bool get isdarkmode => _themeData == darkgreymode;

  set themeData (ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggletheme () {
    if (_themeData == lightmode) {
      themeData = darkmode;
    } 
    if (_themeData == darkmode) {
      themeData = darkgreymode;
    } 
    if (_themeData == darkgreymode) {
      themeData = lightgreymode;
    } else {
      themeData = lightmode;
    }
  }

  void settheme (String targettheme) {
    if (targettheme == "Dark") {
      themeData = darkmode;
    } 
    else if (targettheme == "Dark Grey") {
      themeData = darkgreymode;
    } 
    else if (targettheme == "Light Grey") {
      themeData = lightgreymode;
    } 
    else {
      themeData = lightmode;
    }
  }
}