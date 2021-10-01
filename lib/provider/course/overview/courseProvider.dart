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
  Map<Semester, List<Course>> _courses;

  final WebClient _client = WebClient();

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
    List<Semester> uninitialised = initialized(semesters);
    if (uninitialised.isNotEmpty) {
      forceUpdate(context, userID, uninitialised);
    }

    //Filter courses by the given list of semesters
    List<Course> courses = <Course>[];
    semesters.forEach((semester) {
      for (Course course in _courses[semester]) {
        if (!courses.contains(course)) {
          courses.add(course);
        }
      }
    });
    return Future<List<Course>>.value(courses);
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

  void forceUpdate(BuildContext context, String userID, List<Semester> semesters) async {
    _courses ??= <Semester, List<Course>>{};

    await Future.forEach(semesters, (Semester semester) async {
      if (semester == null) {
        return;
      }

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

        if (!_courses.containsKey(semester)) {
          _courses[semester] = <Course>[];
        }

        _courses[semester].add(course);
      });
    });

    notifyListeners();
  }

  void resetCache() {
    _courses = null;
  }
}
