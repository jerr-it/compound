import 'dart:async';
import 'dart:convert';

import 'package:compound/net/webClient.dart';
import 'package:compound/provider/course/courseHtmlParser.dart';
import 'package:compound/provider/course/courseModel.dart';
import 'package:compound/provider/course/coursePreviewModel.dart';
import 'package:compound/provider/course/semester/semesterFilter.dart';
import 'package:compound/provider/course/semester/semesterModel.dart';
import 'package:compound/provider/course/semester/semesterProvider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

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

///This provider provides the data for the courses themselves *and* the overview tab
class CourseProvider extends ChangeNotifier {
  final WebClient _client = WebClient();

  //Stores all courses, grouped by semester
  Map<Semester, List<Course>> _courses;

  CoursePageHtmlParser _parser = CoursePageHtmlParser();
  CoursePageHtmlParser get parser => this._parser;

  //Caches image data of course images (To reduce traffic)
  //Prebuilt packages like cached_network_image exist
  //but at the time of making this don't really meet the needs
  //mainly due to broken error handling in case of urls that don't point to an image
  //https://github.com/flutter/flutter/issues/81931
  MemoryImage _genericCourseImage;
  MemoryImage _genericStudyGroupImage;
  //CourseID -> Image
  Map<String, MemoryImage> _courseImages;

  //Returns a list of semesters that haven't been initialised yet
  //This way we only initialise the ones we don't already have data of
  List<Semester> initialized(List<Semester> semesters) {
    if (_courses == null) {
      return semesters;
    }

    List<Semester> uninitialised = <Semester>[];
    for (Semester sem in semesters) {
      if (!_courses.containsKey(sem)) {
        uninitialised.add(sem);
      }
    }
    return uninitialised;
  }

  Future<List<Course>> get(BuildContext context, String userID, List<Semester> semesters) async {
    if (_courseImages == null) {
      _courseImages = <String, MemoryImage>{};

      http.Response res = await http.get(Uri.parse(getEmptyLogo(CourseType.Lecture)));
      _genericCourseImage = MemoryImage(res.bodyBytes);

      res = await http.get(Uri.parse(getEmptyLogo(CourseType.StudyGroup)));
      _genericStudyGroupImage = MemoryImage(res.bodyBytes);
    }

    List<Semester> uninitialised = initialized(semesters);
    if (uninitialised.isNotEmpty) {
      await forceUpdate(context, userID, uninitialised);
    }

    //Filter courses by the given list of semesters
    List<Course> courses = <Course>[];
    semesters.forEach((semester) {
      if (_courses.containsKey(semester)) {
        for (Course course in _courses[semester]) {
          if (!courses.contains(course)) {
            courses.add(course);
          }
        }
      }
    });
    return Future<List<Course>>.value(courses);
  }

  ///Updates the studip course page setting for the semesterfilter
  Future<void> pushSemesterFilter(SemesterFilter filter) async {
    String url = _client.server.webAddress + "/dispatch.php/my_courses/set_semester";
    await _client.internal.get(
      Uri.parse(url).replace(queryParameters: {"sem_select": filter.toStr()}),
      headers: {"Cookie": _client.sessionCookie},
    );
  }

  ///This function populates the [_parser].
  ///There is no api way to find out if there is something new.
  ///So we have to scrape that data.
  Future<void> _checkNew() async {
    String url = _client.server.webAddress + "/dispatch.php/my_courses";
    http.Response response = await _client.internal.get(
      Uri.parse(url),
      headers: {"Cookie": _client.sessionCookie},
    );

    _parser.scan(response.body);
  }

  ///Mark a certain tab news as seen.
  ///type can be "files", "news", "forum" .... Essentially all the types
  ///that can occur in the html parser.
  void markSeen(String courseNum, String type) {
    _parser.markSeen(courseNum, type);
    notifyListeners();
  }

  ///Returns a given courses image.
  ///Uses the internal cache if possible.
  Future<MemoryImage> getImage(String courseID, CourseType type) async {
    if (_courseImages.containsKey(courseID)) {
      return _courseImages[courseID];
    }

    http.Response res = await http.get(Uri.parse(getLogo(courseID)));
    if (res.statusCode == 200) {
      MemoryImage img = MemoryImage(res.bodyBytes);
      _courseImages[courseID] = img;
      return img;
    }

    return (type == CourseType.StudyGroup ? _genericStudyGroupImage : _genericCourseImage);
  }

  ///Returns the url of a courses icon
  String getLogo(String courseID) {
    return _client.server.webAddress + "/pictures/course/" + courseID + "_medium.png";
  }

  //TODO maybe add different images for each type of course
  String getEmptyLogo(CourseType type) {
    return _client.server.webAddress +
        "/pictures/course/" +
        (type == CourseType.StudyGroup ? "studygroup_medium.png" : "nobody_medium.png");
  }

  ///Forces the CourseProvider to update all courses of the given semesters
  Future<void> forceUpdate(BuildContext context, String userID, List<Semester> semesters) async {
    _courses ??= <Semester, List<Course>>{};

    await Future.forEach(semesters, (Semester semester) async {
      if (semester == null) {
        return;
      }

      _courses.remove(semester);

      String route = "/user/$userID/courses";

      http.Response res = await _client.httpGet(route, APIType.REST, urlParams: {"semester": semester.semesterID});
      Map<String, dynamic> decoded = jsonDecode(res.body);

      try {
        Map<String, dynamic> courseMap = decoded["collection"];

        await Future.forEach(courseMap.keys, (courseKey) async {
          Map<String, dynamic> courseData = courseMap[courseKey];

          String startSemesterID = courseData["start_semester"].toString().split("/").last;
          SemesterFilter sfilter = SemesterFilter(FilterType.SPECIFIC, startSemesterID);
          Semester start = Provider.of<SemesterProvider>(context, listen: false).get(sfilter).first;

          String endSemesterID = courseData["end_semester"].toString().split("/").last;
          SemesterFilter efilter = SemesterFilter(FilterType.SPECIFIC, endSemesterID);
          Semester end = Provider.of<SemesterProvider>(context, listen: false).get(efilter).first;

          Course course = Course.fromMap(courseData, start, end);

          if (!_courses.containsKey(semester)) {
            _courses[semester] = <Course>[];
          }

          _courses[semester].add(course);
        });

        _courses[semester].sort((Course a, Course b) {
          return (a.color.value - b.color.value) + (b.number.compareTo(a.number));
        });
      } catch (e) {}
    });

    await _checkNew();
    notifyListeners();
  }

  ///Used by the search page.
  ///Searches all studip courses for matches.
  Future<List<CoursePreview>> searchFor(BuildContext context, String searchStr) async {
    List<CoursePreview> courses = <CoursePreview>[];
    if (searchStr == null || searchStr.isEmpty) {
      return courses;
    }

    http.Response response = await _client.httpGet("/courses", APIType.JSON, urlParams: <String, dynamic>{
      "filter[q]": searchStr,
      "filter[fields]": "all", //TODO add filter options http://jsonapi.elan-ev.de/?shell#schema-quot-course-memberships-quot
    });

    List<dynamic> decodedCourses = jsonDecode(response.body)["data"];

    decodedCourses.forEach((entry) {
      Map<String, dynamic> coursePreviewData = entry as Map<String, dynamic>;

      String startSemesterID = coursePreviewData["relationships"]["start-semester"]["data"]["id"];
      SemesterFilter sfilter = SemesterFilter(FilterType.SPECIFIC, startSemesterID);
      Semester start = Provider.of<SemesterProvider>(context, listen: false).get(sfilter).first;

      if (coursePreviewData["relationships"]["end-semester"] != null) {
        String endSemesterID = coursePreviewData["relationships"]["end-semester"]["data"]["id"];
        SemesterFilter efilter = SemesterFilter(FilterType.SPECIFIC, endSemesterID);
        Semester end = Provider.of<SemesterProvider>(context, listen: false).get(efilter).first;

        courses.add(CoursePreview.fromData(coursePreviewData, start, end));
      } else {
        courses.add(CoursePreview.fromData(coursePreviewData, start, null));
      }
    });

    return Future<List<CoursePreview>>.value(courses);
  }

  ///Signs the user up for a course.
  ///There doesn't seem to be a route in REST or JSON for signing up for a course.
  ///So this 'imitates' the action done in a browser.
  Future<http.Response> signup(String courseID) async {
    //Extract the security token from the html page
    http.Response res = await WebClient().internal.get(
      Uri.parse(_client.server.webAddress + "/dispatch.php/course/enrolment/apply/$courseID"),
      headers: <String, String>{"Cookie": WebClient().sessionCookie},
    );

    String tag = "<input type=\"hidden\" name=\"security_token\" value=\"";
    int start = res.body.indexOf(tag) + tag.length;
    int end = res.body.indexOf(">", start) - 1;

    String securityToken = res.body.substring(start, end);

    return WebClient().internal.post(
      Uri.parse(_client.server.webAddress + "/dispatch.php/course/enrolment/apply/$courseID"),
      headers: <String, String>{"Cookie": WebClient().sessionCookie},
      body: {
        "apply": "1",
        "security_token": securityToken,
        "yes": "",
      },
    );
  }

  ///Signs the user out of a given course
  ///There doesn't seem to be a route in REST or JSON for siging out of a course either.
  ///So this 'imitates' the action done in a browser.
  Future<http.Response> signout(String courseID) async {
    //Extract the security token and studip ticket(?) from the html page
    http.Response res = await WebClient().internal.get(
      Uri.parse(_client.server.webAddress + "/dispatch.php/my_courses/decline/$courseID?cmd=suppose_to_kill"),
      headers: <String, String>{"Cookie": WebClient().sessionCookie},
    );

    String secTag = "<input type=\"hidden\" name=\"security_token\" value=\"";
    int secStart = res.body.indexOf(secTag) + secTag.length;
    int secEnd = res.body.indexOf(">", secStart) - 1;

    String securityToken = res.body.substring(secStart, secEnd);

    String ticketTag = "<input type=\"hidden\" name=\"studipticket\" value=\"";
    int ticketStart = res.body.indexOf(ticketTag) + ticketTag.length;
    int ticketEnd = res.body.indexOf(">", ticketStart) - 1;

    String studipTicket = res.body.substring(ticketStart, ticketEnd);

    return WebClient().internal.post(
      Uri.parse(_client.server.webAddress + "/dispatch.php/my_courses/decline/$courseID"),
      headers: <String, String>{"Cookie": WebClient().sessionCookie},
      body: {
        "security_token": securityToken,
        "cmd": "kill",
        "studipticket": studipTicket,
      },
    );
  }

  void resetCache() {
    _courses = null;
  }
}
