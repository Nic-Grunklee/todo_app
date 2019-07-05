import 'package:flutter/material.dart';
import 'package:todo_app/data/database.dart';
import 'package:todo_app/data/preference_model.dart';

class ThemeState with ChangeNotifier {
  ThemeData _themeData;
  ThemeData light = ThemeData.light();
  ThemeData dark = ThemeData.dark();

  bool isDark = true;

  ThemeState() {
    init();
  }

  ThemeData getTheme () => _themeData;

  Future<void> init() async {
    await _getAllPrefences();
    Preference value = _prefs.firstWhere((pref) => pref.key == 'theme');
    String theme = value.value;
    if(theme == 'light') {
      _themeData = light;
    } else if(theme == 'dark') {
      _themeData = dark;
    }
    notifyListeners();
  }

  setTheme() async { 
    Preference themeData = _prefs.firstWhere((pref) => pref.key == 'theme');
    if(themeData.value == 'dark') {
      themeData.value = 'light';
    } else if (themeData.value =='light') {
      themeData.value = 'dark';
    }

    await DBProvider.db.changePreferenceSetting(themeData);
    await init();
  }

  List<Preference> _prefs = [];

  _getAllPrefences() async {
    await DBProvider.db.getAllPrefences().then((result) => {
      _prefs = result
    });
  }
}