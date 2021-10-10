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

///Abstracts StudIP internal mail messages
class Message {
  String _id;

  String _subject;
  String _content;
  String _contentHTML;

  int _mkdate;
  String _priority;
  bool _read;

  List<String> _tags;

  User _sender;

  String get id => this._id;

  String get subject => this._subject;
  String get content => this._content;
  String get contentHTML => this._contentHTML;

  int get mkdate => this._mkdate;
  String get priority => this._priority;
  bool get read => this._read;
  set read(value) => this._read = value;

  List<String> get tags => this._tags;

  User get sender => this._sender;

  Message.fromMap(Map<String, dynamic> data, User sender) {
    _id = data["message_id"];

    _subject = data["subject"];
    _content = data["message"];
    _contentHTML = data["message_html"];

    _mkdate = int.parse(data["mkdate"]);
    _priority = data["priority"];
    _read = !data["unread"];
    _tags = List<String>.from(data["tags"]);

    _sender = sender;
  }
}
