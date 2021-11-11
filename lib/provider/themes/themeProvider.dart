import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

///Manages themes and swapping them
class ThemeController extends ChangeNotifier {
  static Map<String, ThemeData> presets = <String, ThemeData>{
    "dark": ThemeData.dark().copyWith(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSwatch().copyWith(primary: Color.fromRGBO(7, 90, 158, 1.0)),
      appBarTheme: AppBarTheme(color: Color.fromRGBO(7, 90, 158, 1.0)),
    ),
    "light": ThemeData.light(),
  };

  ThemeData _themeData;
  String _key;

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("theme_key")) {
      _key = prefs.getString("theme_key");
      _themeData = presets[_key];

      notifyListeners();
      return;
    }
    _themeData = presets["light"];
    _key = "light";
    notifyListeners();
  }

  ThemeData get theme => _themeData;
  String get key => _key;

  void setTheme(String presetName) async {
    _themeData = presets[presetName];
    _key = presetName;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("theme_key", presetName);

    notifyListeners();
  }
}
