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

//Inspect the studip course overview for more info concerning the structure

///Scans a html page for new category content of the studip course overview
class CoursePageHtmlParser {
  Map<String, List<String>> _new = {};

  /// [tab] can be files, forum etc.
  /// Returns whether or not there is new data in this tab
  bool hasNew(String courseNum, String tab) {
    if (!_new.containsKey(courseNum)) {
      return false;
    }
    return _new[courseNum].contains(tab);
  }

  void scan(String htmlDoc) {
    _parseHTML(htmlDoc);
  }

  void _parseHTML(String data) {
    Document document = parse(data);

    //Contains all visible semesters
    //<div id="my_seminars>...</div>"
    Element coursesDiv = document.getElementById("my_seminars");

    //Iterate all of the selected semesters
    //<table class="default collapsable mycourses">...</table>
    coursesDiv.children.forEach((Element semester) {
      //<tbody>...</tbody>
      Element courseList = semester.children[3];

      //Iterate courses of a semester
      //<tr>...</tr>
      courseList.children.forEach((Element course) {
        //<td>:courseNumber</tr>
        Element courseNumberElt = course.children[2];
        String courseNumber = courseNumberElt.innerHtml;

        //<td class="hidden-small-down" style="text-aling: left; white-space: nowrap;">...</td>
        Element badgeContainer = course.children[5];

        //<a class="badge">...</a> to only get the ones with new data
        List<Element> badges = badgeContainer.getElementsByClassName("badge");
        _new[courseNumber] = [];

        badges.forEach((Element badge) {
          String imgSrc = badge.children.first.attributes["src"];
          String category = imgSrc.split("/").last.split(".").first;

          _new[courseNumber].add(category);
        });
      });
    });
  }
}
