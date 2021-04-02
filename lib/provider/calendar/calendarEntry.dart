class CalendarEntry {
  int _start;
  int _end;

  String _title;
  String _content;

  String _color;

  get start => this._start;
  get end => this._end;

  get title => this._title;
  get content => this._content;

  get color => this._color;

  CalendarEntry.fromMap(Map<String, dynamic> data) {
    _start = data["start"];
    _end = data["end"];

    _title = data["title"];
    _content = data["content"];

    _color = data["color"];
  }
}
