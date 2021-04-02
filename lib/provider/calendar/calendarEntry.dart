class CalendarEntry {
  int _start;
  int _end;

  String _title;
  String _content;

  String _color;

  int get start => this._start;
  int get end => this._end;

  String get title => this._title;
  String get content => this._content;

  String get color => this._color;

  CalendarEntry.fromMap(Map<String, dynamic> data) {
    _start = data["start"];
    _end = data["end"];

    _title = data["title"];
    _content = data["content"];

    _color = data["color"];
  }
}
