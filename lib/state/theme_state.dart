import 'package:flutter/material.dart';

class ThemeState with ChangeNotifier {
  ThemeData _themeData;
  ThemeData light = ThemeData.light();
  ThemeData dark = ThemeData.dark();

  bool isDark = true;

  ThemeState() {
    _themeData = dark;
  }

  ThemeData getTheme () => _themeData;

  setTheme() {
    if (isDark) {
      _themeData = light;
    } else {
      _themeData = dark;
    }
    isDark = !isDark;
    notifyListeners();
  }
}