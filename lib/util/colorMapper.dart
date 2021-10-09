import 'package:flutter/material.dart';

// Compound - Mobile StudIP client
// Copyright (C) 2021 Jerrit Gläsker

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
