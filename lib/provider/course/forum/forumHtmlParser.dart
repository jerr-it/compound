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

class NewForumEntry {
  NewForumEntry(String loc, String id)
      : location = loc,
        fId = id;

  final String location;
  final String fId;
}

List<NewForumEntry> _buildNewForumEntries(List<String> ids, List<String> topics) {
  List<NewForumEntry> entries = [];
  for (int i = 0; i < ids.length; i++) {
    entries.add(NewForumEntry(topics[i], ids[i]));
  }
  return entries;
}

class ForumHtmlParser {
  static List<NewForumEntry> scan(String htmlDoc) {
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

    List<String> topics = [];
    List<Element> bodyDivs =
        document.getElementsByClassName("postbody").where((element) => !element.attributes.containsKey("id")).toList();
    bodyDivs.forEach((Element bodyDiv) {
      String topic = bodyDiv.children[0].children[2].children[0].innerHtml;
      topics.add(topic);
    });

    return _buildNewForumEntries(newIDs, topics);
  }
}
