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
  String _userID;

  final WebClient _client = WebClient();

  void setUserID(String uID) {
    _userID = uID;
  }

  bool initialized() {
    return _courses != null;
  }

  Future<void> update() async {
    _courses ??= <Course>[];
    String route = "/user/$_userID/courses";

    Response res = await _client.httpGet(route);
    Map<String, dynamic> decoded = jsonDecode(res.body);
    Map<String, dynamic> courseMap = decoded["collection"];

    await Future.forEach(courseMap.keys, (courseKey) async {
      Map<String, dynamic> courseData = courseMap[courseKey];

      String startSemesterRoute = courseData["start_semester"].toString().replaceFirst("/api.php", "");
      Response res = await _client.httpGet(startSemesterRoute);
      Semester start = Semester.fromMap(jsonDecode(res.body));

      String endSemesterRoute = courseData["end_semester"].toString().replaceFirst("/api.php", "");
      res = await _client.httpGet(endSemesterRoute);
      Semester end = Semester.fromMap(jsonDecode(res.body));

      _courses.add(Course.fromMap(courseData, start, end));
    });

    notifyListeners();
  }

  List<Course> courses() {
    return _courses;
  }
}
