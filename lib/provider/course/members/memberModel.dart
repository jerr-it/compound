import 'package:fludip/provider/user/userModel.dart';

class Members {
  List<User> _lecturers;
  List<User> _tutors;
  List<User> _studends;

  get lecturers => this._lecturers;
  get tutors => this._tutors;
  get studends => this._studends;

  Members.from(List<User> lecturers, List<User> tutors, List<User> students) {
    _lecturers = lecturers;
    _tutors = tutors;
    _studends = students;
  }
}
