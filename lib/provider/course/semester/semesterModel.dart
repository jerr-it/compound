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

class Semester {
  String _title;
  String _description;

  String _semesterID;

  int _begin;
  int _end;

  int _seminarsBegin;
  int _seminarsEnd;

  String get title => this._title;
  String get description => this._description;

  String get semesterID => this._semesterID;

  int get begin => this._begin;
  int get end => this._end;

  int get seminarsBegin => this._seminarsBegin;
  int get seminarsEnd => this._seminarsEnd;

  Semester.fromMap(Map<String, dynamic> data) {
    _title = data["title"];
    _description = data["description"];

    _semesterID = data["id"];

    _begin = data["begin"];
    _end = data["end"];

    _seminarsBegin = data["seminars_begin"];
    _seminarsEnd = data["seminars_end"];
  }

  Semester.empty() {
    _title = "unlimited";
  }
}
