import 'package:flutter/material.dart';
import 'package:todo_app/data/database.dart';
import 'package:todo_app/data/preference_model.dart';

class ThemeState with ChangeNotifier {
  ThemeData _themeData;
  ThemeData light = ThemeData.light();
  ThemeData dark = ThemeData.dark();

  bool isDark = false;

  ThemeState() {
    init();
  }

  ThemeData getTheme() => _themeData;

  Future<void> init() async {
    Preference theme;
    await _getAllPrefences();
    var result =
        _prefs.firstWhere((pref) => pref.key == 'theme', orElse: () => null);
    if(result != null) {
       theme = _prefs.firstWhere((pref) => pref.key == 'theme');
    } else {
      theme = new Preference();
      theme.key = 'theme';
      theme.value = 'light';
      await DBProvider.db.newPreference(theme);
    }
    if (theme.value == 'light') {
      _themeData = light;
      isDark = false;
    } else if (theme.value == 'dark') {
      _themeData = dark;
      isDark = true;
    }
    await _getAllPrefences();
    notifyListeners();
  }

  setTheme() async {
    Preference themeData = _prefs.firstWhere((pref) => pref.key == 'theme');
    if (themeData.value == 'dark') {
      themeData.value = 'light';
    } else if (themeData.value == 'light') {
      themeData.value = 'dark';
    }

    await DBProvider.db.changePreferenceSetting(themeData);
    await init();
  }

  List<Preference> _prefs = [];

  _getAllPrefences() async {
    await DBProvider.db.getAllPrefences().then((result) => _prefs = result);
  }
}
