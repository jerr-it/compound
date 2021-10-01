import 'dart:convert';
import 'dart:async';

import 'package:fludip/provider/course/semester/semesterFilter.dart';
import 'package:fludip/provider/course/semester/semesterProvider.dart';
import 'package:http/http.dart';

import 'package:flutter/material.dart';

import 'package:fludip/net/webClient.dart';
import 'package:fludip/provider/course/overview/courseModel.dart';
import 'package:fludip/provider/course/semester/semesterModel.dart';
import 'package:provider/provider.dart';

///This provider provides the data for the courses themselves *and* the overview tab
class CourseProvider extends ChangeNotifier {
  List<Course> _courses;

  final WebClient _client = WebClient();

  bool initialized() {
    return _courses != null;
  }

  Future<List<Course>> get(BuildContext context, String userID, List<Semester> semesters) async {
    if (!initialized()) {
      return forceUpdate(context, userID, semesters);
    }

    return Future<List<Course>>.value(_courses);
  }

  String getLogo(String courseID) {
    return _client.server.webAddress + "/pictures/course/" + courseID + "_medium.png";
  }

  //TODO maybe add different images for each type of course
  String getEmptyLogo(CourseType type) {
    return _client.server.webAddress +
        "/pictures/course/" +
        (type == CourseType.StudyGroup ? "studygroup_medium.png" : "nobody_medium.png");
  }

  Future<List<Course>> forceUpdate(BuildContext context, String userID, List<Semester> semesters) async {
    _courses ??= <Course>[];
    if (_courses.isNotEmpty) {
      _courses.clear();
    }

    await Future.forEach(semesters, (Semester semester) async {
      String route = "/user/$userID/courses?semester=" + semester.semesterID;

      Response res = await _client.httpGet(route, APIType.REST);
      Map<String, dynamic> decoded = jsonDecode(res.body);
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
        if (!_courses.contains(course)) {
          _courses.add(course);
        }
      });
    });

    notifyListeners();
    return Future<List<Course>>.value(_courses);
  }

  void resetCache() {
    _courses = null;
  }
}
