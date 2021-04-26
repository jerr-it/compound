import 'dart:convert';
import 'dart:async';

import 'package:fludip/provider/news/newsModel.dart';
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

  Future<List<Course>> update(String userID) async {
    if (!initialized()) {
      return fetch(userID);
    }

    return Future<List<Course>>.value(_courses);
  }

  Future<List<Course>> fetch(String userID) async {
    _courses ??= <Course>[];
    if (_courses.isNotEmpty) {
      _courses.clear();
    }

    String route = "/user/$userID/courses";

    Response res = await _client.httpGet(route);
    Map<String, dynamic> decoded = jsonDecode(res.body);
    Map<String, dynamic> courseMap = decoded["collection"];

    await Future.forEach(courseMap.keys, (courseKey) async {
      Map<String, dynamic> courseData = courseMap[courseKey];

      Semester start;
      try {
        String startSemesterRoute = courseData["start_semester"].toString().split("/api.php")[1];
        Response res = await _client.httpGet(startSemesterRoute);
        start = Semester.fromMap(jsonDecode(res.body));
      } catch (e) {
        start = Semester.empty();
      }

      Semester end;
      try {
        String endSemesterRoute = courseData["end_semester"].toString().split("/api.php")[1];
        res = await _client.httpGet(endSemesterRoute);
        end = Semester.fromMap(jsonDecode(res.body));
      } catch (e) {
        end = Semester.empty();
      }

      String courseID = courseData["course_id"];
      String announcementsRoute = "/course/$courseID/news";
      res = await _client.httpGet(announcementsRoute);

      Map<String, dynamic> announcementsData = jsonDecode(res.body)["collection"];
      List<News> news = <News>[];
      announcementsData.forEach((announcementKey, announcement) {
        news.add(News.fromMap(announcement));
      });

      _courses.add(Course.fromMap(courseData, start, end, news));
    });

    notifyListeners();
    return Future<List<Course>>.value(_courses);
  }
}
