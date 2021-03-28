import 'package:fludip/provider/course/overview/semesterModel.dart';

class Course {
  String _courseID;

  String _title;
  String _subtitle;
  String _description;

  String _type;
  int _group;
  int _number;

  String _location;

  Semester _startSemester;
  Semester _endSemester;

  get courseID => this._courseID;

  get title => this._title;
  get subtitle => this._subtitle;
  get description => this._description;

  get type => this._type;
  get group => this._group;
  get number => this._number;

  get location => this._location;

  get startSemester => this._startSemester;
  get endSemester => this._endSemester;

  Course.fromMap(Map<String, dynamic> data, Semester start, Semester end) {
    _courseID = data[_courseID];

    _title = data["title"];
    _subtitle = data["subtitle"];
    _description = data["description"];

    _type = data["type"];
    _group = data["group"];
    _number = int.parse(data["number"]);

    _location = data["location"];

    _startSemester = start;
    _endSemester = end;
  }
}
