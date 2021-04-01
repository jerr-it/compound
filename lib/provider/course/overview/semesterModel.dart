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
