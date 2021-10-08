//A course you haven't yet signed up for
//Used for the search page
import 'package:fludip/provider/course/courseModel.dart';
import 'package:fludip/provider/course/semester/semesterModel.dart';

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

class CoursePreview {
  String _courseID;
  String _number;

  String _title;
  String _subtitle;
  String _description;

  CourseType _type;
  String _location;

  Semester _startSemester;
  Semester _endSemester;

  String get courseID => this._courseID;
  String get number => this._number;

  String get title => this._title;
  String get subtitle => this._subtitle;
  String get description => this._description;

  CourseType get type => this._type;

  String get location => this._location;

  Semester get startSemester => this._startSemester;
  Semester get endSemester => this._endSemester;

  CoursePreview.fromData(Map<String, dynamic> data, Semester start, Semester end) {
    _courseID = data["id"];
    _number = data["attributes"]["course-number"];

    _title = data["attributes"]["title"];
    _subtitle = data["attributes"]["subtitle"];
    _description = data["attributes"]["description"];

    _type = CourseMapper[data["attributes"]["course-type"].toString()];
    _location = data["attributes"]["location"];

    _startSemester = start;
    _endSemester = end;
  }
}
