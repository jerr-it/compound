import 'package:compound/provider/course/semester/semesterModel.dart';
import 'package:compound/util/colorMapper.dart';
import 'package:flutter/material.dart';

// Fludip - Mobile StudIP client
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

enum CourseType {
  Lecture,
  Seminar,
  Exercise,
  PracticalTraining,
  Colloquium,
  ResearchGroup,
  TeachingMisc,
  Committee,
  ProjectGroup,
  SeminarMisc,
  CultureForum,
  CourseBoard,
  CommunityMisc,
  StudyGroup,
}

final CourseMapper = const {
  "1": CourseType.Lecture,
  "2": CourseType.Seminar,
  "3": CourseType.Exercise,
  "4": CourseType.PracticalTraining,
  "5": CourseType.Colloquium,
  "6": CourseType.ResearchGroup,
  "7": CourseType.TeachingMisc,
  "8": CourseType.Committee,
  "9": CourseType.ProjectGroup,
  "10": CourseType.SeminarMisc,
  "11": CourseType.CultureForum,
  "12": CourseType.CourseBoard,
  "13": CourseType.CommunityMisc,
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

  set endSemester(Semester semester) => this._endSemester = semester;

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

  @override
  bool operator ==(other) {
    return (other is Course) && this.courseID == other.courseID;
  }

  @override
  int get hashCode => this.courseID.hashCode;
}
