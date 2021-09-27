import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart';

import 'package:flutter/material.dart';

import 'package:fludip/net/webClient.dart';
import 'package:fludip/provider/course/overview/courseModel.dart';
import 'package:fludip/provider/course/overview/semesterModel.dart';

///This provider provides the data for the courses themselves *and* the overview tab
class GeneralCourseProvider extends ChangeNotifier {
  List<Course> _courses;

  final WebClient _client = WebClient();

  bool initialized() {
    return _courses != null;
  }

  Future<List<Course>> get(String userID) async {
    if (!initialized()) {
      return forceUpdate(userID);
    }

    return Future<List<Course>>.value(_courses);
  }

  String getLogo(String courseID) {
    return _client.server.webAddress + "/pictures/course/" + courseID + "_medium.png";
  }

  String getEmptyLogo() {
    return _client.server.webAddress + "/pictures/course/nobody_medium.png";
  }

  Future<List<Course>> forceUpdate(String userID) async {
    _courses ??= <Course>[];
    if (_courses.isNotEmpty) {
      _courses.clear();
    }

    String route = "/user/$userID/courses";

    Response res = await _client.httpGet(route, APIType.REST);
    Map<String, dynamic> decoded = jsonDecode(res.body);
    Map<String, dynamic> courseMap = decoded["collection"];

    await Future.forEach(courseMap.keys, (courseKey) async {
      Map<String, dynamic> courseData = courseMap[courseKey];

      Semester start;
      try {
        String startSemesterRoute = courseData["start_semester"].toString().split("/api.php")[1];
        Response res = await _client.httpGet(startSemesterRoute, APIType.REST);
        start = Semester.fromMap(jsonDecode(res.body));
      } catch (e) {
        start = Semester.empty();
      }

      Semester end;
      try {
        String endSemesterRoute = courseData["end_semester"].toString().split("/api.php")[1];
        res = await _client.httpGet(endSemesterRoute, APIType.REST);
        end = Semester.fromMap(jsonDecode(res.body));
      } catch (e) {
        end = Semester.empty();
      }
      _courses.add(Course.fromMap(courseData, start, end));
    });

    notifyListeners();
    return Future<List<Course>>.value(_courses);
  }

  void resetCache() {
    _courses = null;
  }
}
