// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:efishxs/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  SharedPreferences? _prefs;
  late ThemeData _themeData;
  bool _themeLoaded = false;

  ThemeProvider() {
    _themeData = darkgreymode; // Default theme
    // _loadThemeData();
  }

  Future<void> _loadThemeData() async {
    _prefs ??= await SharedPreferences.getInstance();

    try {
      int? selectedthemeindex = _prefs?.getInt("settings/general/theme");
      String selectedtheme = ["Dark", "Dark Grey", "Light Grey", "Light"][selectedthemeindex ?? 0];

      print("Selected theme: $selectedtheme");

      if (selectedtheme == "Dark") {
        _themeData = darkmode;
      } 
      else if (selectedtheme == "Dark Grey") {
        _themeData = darkgreymode;
      }
      else if (selectedtheme == "Light Grey") {
        _themeData = lightgreymode;
      }
      else if (selectedtheme == "Light") {
        _themeData = lightmode;
      }
      _themeLoaded = true;

      // notifyListeners();
    }
    catch (e) {
      print (e);
    }
  }

  ThemeData get themeData {
    if (!_themeLoaded) {
      _loadThemeData();
    }
    return _themeData;
  }

  bool get isdarkmode => _themeData == darkgreymode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    // notifyListeners();

    SharedPreferences.getInstance().then((value){
      _prefs = value;

      String targettheme;
      if (themeData == darkmode) {
        targettheme = "Dark";
      } 
      else if (themeData == darkgreymode) {
        targettheme = "Dark Grey";
      } 
      else if (themeData == lightgreymode) {
        targettheme = "Light Grey";
      } 
      else {
        targettheme = "Light";
      }
      _prefs?.setInt("settings/general/theme", ["Dark", "Dark Grey", "Light Grey", "Light"].indexOf(targettheme));
    });
  }

  void toggletheme() {
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

  void settheme(String targettheme) {
    print("LOG: Request to set theme: $targettheme");
    
    if (targettheme == "Dark") {
      _themeData = darkmode;
    } 
    else if (targettheme == "Dark Grey") {
      _themeData = darkgreymode;
    } 
    else if (targettheme == "Light Grey") {
      _themeData = lightgreymode;
    } 
    else {
      _themeData = lightmode;
    }
    
    notifyListeners();
  }
}