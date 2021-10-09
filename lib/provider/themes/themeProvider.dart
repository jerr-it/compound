import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Color lighten(Color color, double factor) {
  int red = ((color.red.toDouble()) * (1.0 + factor)).round();
  int green = ((color.green.toDouble()) * (1.0 + factor)).round();
  int blue = ((color.blue.toDouble()) * (1.0 + factor)).round();

  return Color.fromRGBO(red, green, blue, 1.0);
}

Color darken(Color color, double factor) {
  int red = ((color.red.toDouble()) * (1.0 - factor)).round();
  int green = ((color.green.toDouble()) * (1.0 - factor)).round();
  int blue = ((color.blue.toDouble()) * (1.0 - factor)).round();

  return Color.fromRGBO(red, green, blue, 1.0);
}

MaterialColor generate(Color color) {
  return MaterialColor(color.value, {
    50: lighten(color, 0.5),
    100: lighten(color, 0.4),
    200: lighten(color, 0.3),
    300: lighten(color, 0.2),
    400: lighten(color, 0.1),
    500: color,
    600: darken(color, 0.1),
    700: darken(color, 0.2),
    800: darken(color, 0.3),
    900: darken(color, 0.4),
  });
}

class ThemeController extends ChangeNotifier {
  static Map<String, ThemeData> presets = <String, ThemeData>{
    "dark": ThemeData.dark().copyWith(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: generate(
          Color.fromRGBO(7, 90, 158, 1.0),
        ),
      ),
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
