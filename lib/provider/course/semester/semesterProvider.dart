import 'dart:convert';

import 'package:fludip/net/webClient.dart';
import 'package:fludip/provider/course/semester/semesterFilter.dart';
import 'package:fludip/provider/course/semester/semesterModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class SemesterProvider extends ChangeNotifier {
  List<Semester> _semesters;

  Semester _current;
  Semester _next;
  Semester _last;

  List<SemesterFilter> _filterOptions;

  List<SemesterFilter> get filterOptions => _filterOptions;

  final WebClient _client = WebClient();

  bool initialized() {
    return _semesters != null;
  }

  List<Semester> get(SemesterFilter filter) {
    List<Semester> sems = <Semester>[];

    switch (filter.type) {
      case FilterType.CURRENT:
        sems.add(_current);
        break;
      case FilterType.CURRENT_NEXT:
        sems.add(_current);
        sems.add(_next);
        break;
      case FilterType.LAST_CURRENT:
        sems.add(_current);
        sems.add(_last);
        break;
      case FilterType.LAST_CURRENT_NEXT:
        sems.add(_current);
        sems.add(_last);
        sems.add(_next);
        break;
      case FilterType.ALL:
        return _semesters;
        break;
      case FilterType.SPECIFIC:
        sems.add(_semesters.firstWhere((semester) => semester.semesterID == filter.id, orElse: () => null));
        break;
    }
    return sems;
  }

  void init() async {
    if (initialized()) {
      return;
    }

    _semesters ??= <Semester>[];
    if (_semesters.isNotEmpty) {
      _semesters.clear();
    }

    String route = "/semesters";
    Response res = await _client.httpGet(route, APIType.REST);
    Map<String, dynamic> decoded = jsonDecode(res.body);
    Map<String, dynamic> semesterMap = decoded["collection"];

    semesterMap.forEach((route, data) {
      _semesters.add(Semester.fromMap(data));
    });

    //Sort semesters from newest to oldest
    _semesters.sort((Semester a, Semester b) {
      return b.end - a.end;
    });

    _determineCurrentLastNext();
    _generateFilterOptions();
  }

  void _determineCurrentLastNext() {
    if (!initialized()) {
      init();
    }

    if (_current == null) {
      int now = DateTime.now().millisecondsSinceEpoch;
      for (Semester sem in _semesters) {
        if (sem.begin * 1000 < now && now < sem.end * 1000) {
          _current = sem;
          break;
        }
      }
    }

    int currentPos = _semesters.indexOf(_current);
    try {
      _next = _semesters[currentPos - 1];
    } catch (e) {
      _next = null;
    }

    try {
      _last = _semesters[currentPos + 1];
    } catch (e) {
      _last = null;
    }
  }

  void _generateFilterOptions() {
    _filterOptions = <SemesterFilter>[
      SemesterFilter(FilterType.ALL, null),
      SemesterFilter(FilterType.CURRENT, null),
      SemesterFilter(FilterType.CURRENT_NEXT, null),
      SemesterFilter(FilterType.LAST_CURRENT, null),
      SemesterFilter(FilterType.LAST_CURRENT_NEXT, null),
    ];

    _semesters.forEach((semester) {
      _filterOptions.add(SemesterFilter(FilterType.SPECIFIC, semester.semesterID));
    });
  }
}
