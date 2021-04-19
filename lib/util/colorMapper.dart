import 'package:flutter/material.dart';

///Maps group number to color
class ColorMapper {
  static final Map<int, Color> _colors = {
    0: Color.fromARGB(255, 104, 44, 139),
    1: Color.fromARGB(255, 176, 46, 124),
    2: Color.fromARGB(255, 214, 0, 0),
    3: Color.fromARGB(255, 242, 110, 0),
    4: Color.fromARGB(255, 255, 189, 51),
    5: Color.fromARGB(255, 110, 173, 16),
    6: Color.fromARGB(255, 0, 133, 18),
    7: Color.fromARGB(255, 18, 156, 148),
    8: Color.fromARGB(255, 168, 93, 69),
  };

  static Color convert(int group) {
    return _colors[group];
  }
}
