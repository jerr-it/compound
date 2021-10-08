import 'package:compound/provider/user/userModel.dart';

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

class ForumEntry {
  User _user;

  String _subject;
  String _content;
  String _contentHTML;

  int _mkdate;
  int _chdate;

  String _anonymous;
  String _depth;

  User get user => this._user;
  set user(User user) => this._user = user;

  String get subject => this._subject;
  String get content => this._content;
  String get contentHTML => this._contentHTML;

  int get mkdate => this._mkdate;
  int get chdate => this._chdate;

  String get anonymous => this._anonymous;
  String get depth => this._depth;

  ForumEntry.fromMap(Map<String, dynamic> data) {
    _subject = data["subject"];
    _content = data["content"];
    _contentHTML = data["content_html"];

    _mkdate = int.parse(data["mkdate"]);
    _chdate = int.parse(data["chdate"]);

    _anonymous = data["anonymous"];
    _depth = data["depth"];
  }
}
