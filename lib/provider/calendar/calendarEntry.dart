// Compound - Mobile StudIP client
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

///Abstracts a StudIP calendar entry
class CalendarEntry {
  int _start;
  int _end;

  String _title;
  String _content;

  int _color;

  int get start => this._start;
  int get end => this._end;

  String get title => this._title;
  String get content => this._content;

  int get color => this._color;

  CalendarEntry.fromMap(Map<String, dynamic> data) {
    _start = data["start"];
    _end = data["end"];

    _title = data["title"];
    _content = data["content"];

    _color = int.parse(data["color"]);
  }
}
