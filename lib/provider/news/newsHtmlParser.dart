import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

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

///Scans html page for new course announcements
class NewsHtmlParser {
  /// Returns a list of news ids that are new
  static List<String> scan(String htmlDoc) {
    List<String> ids = [];

    Document document = parse(htmlDoc);

    Element container = document.getElementById("layout_content");

    Element articleContainer = container.children[1];

    articleContainer.children.forEach((element) {
      if (element.className.contains("studip toggle new")) {
        ids.add(element.id);
      }
    });

    return ids;
  }
}
