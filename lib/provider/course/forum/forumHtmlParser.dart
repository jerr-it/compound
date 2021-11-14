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

class ForumHtmlParser {
  static List<String> scan(String htmlDoc) {
    List<String> newIDs = [];

    Document document = parse(htmlDoc);

    //<div id="forum">
    Element forumDiv = document.getElementById("forum");

    //<div style="clear: both">
    Element entriesContainer = forumDiv.children[1];

    List<Element> entries = entriesContainer.children.where((element) => element.attributes.containsKey("name")).toList();

    entries.forEach((Element elt) {
      newIDs.add(elt.attributes["name"]);
    });

    return newIDs;
  }
}
