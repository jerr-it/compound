import 'package:compound/provider/user/userModel.dart';

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

class Members {
  List<User> _lecturers;
  List<User> _tutors;
  List<User> _studends;

  List<User> get lecturers => this._lecturers;
  List<User> get tutors => this._tutors;
  List<User> get studends => this._studends;

  Members.from(List<User> lecturers, List<User> tutors, List<User> students) {
    _lecturers = lecturers;
    _tutors = tutors;
    _studends = students;
  }
}
