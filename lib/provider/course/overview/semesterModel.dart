class Semester {
  String _title;
  String _description;

  String _semesterID;

  int _begin;
  int _end;

  int _seminarsBegin;
  int _seminarsEnd;

  get title => this._title;
  get description => this._description;

  get semesterID => this._semesterID;

  get begin => this._begin;
  get end => this._end;

  get seminarsBegin => this._seminarsBegin;
  get seminarsEnd => this._seminarsEnd;

  Semester.fromMap(Map<String, dynamic> data) {
    _title = data["title"];
    _description = data["description"];

    _semesterID = data["id"];

    _begin = data["begin"];
    _end = data["end"];

    _seminarsBegin = data["seminars_begin"];
    _seminarsEnd = data["seminars_end"];
  }
}
