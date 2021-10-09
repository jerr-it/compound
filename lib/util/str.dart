import 'package:intl/intl.dart';

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

class StringUtil {
  static String removeHTMLTags(String text) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return text.replaceAll(exp, '');
  }

  static String fromUnixTime(int timeStamp, String targetFormat) {
    DateFormat formatter = DateFormat(targetFormat);
    DateTime time = new DateTime.fromMillisecondsSinceEpoch(timeStamp);

    return formatter.format(time);
  }
}
