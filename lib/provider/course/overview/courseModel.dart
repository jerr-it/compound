import 'package:fludip/provider/course/overview/semesterModel.dart';
import 'package:fludip/util/colorMapper.dart';
import 'package:flutter/material.dart';

enum CourseType { Lecture, StudyGroup }

final CourseMapper = const {
  "1": CourseType.Lecture,
  "99": CourseType.StudyGroup,
};

class Course {
  String _courseID;

  String _title;
  String _subtitle;
  String _description;

  CourseType _type;
  Color _color;
  String _number;

  String _location;

  Semester _startSemester;
  Semester _endSemester;

  String get courseID => this._courseID;

  String get title => this._title;
  String get subtitle => this._subtitle;
  String get description => this._description;

  CourseType get type => this._type;
  Color get color => this._color;
  String get number => this._number;

  String get location => this._location;

  Semester get startSemester => this._startSemester;
  Semester get endSemester => this._endSemester;

  Course.fromMap(Map<String, dynamic> data, Semester start, Semester end) {
    _courseID = data["course_id"];

    _title = data["title"];
    _subtitle = data["subtitle"];
    _description = data["description"];

    _type = CourseMapper[data["type"]];
    _color = ColorMapper.convert(data["group"]);
    _number = data["number"];

    _location = data["location"];

    _startSemester = start;
    _endSemester = end;
  }
}
