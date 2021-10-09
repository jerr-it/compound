import 'package:compound/provider/blubber/blubberMessageModel.dart';

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

class BlubberThread {
  String _id;
  String _avatarUrl;
  String _name;
  int _timeStamp;

  List<BlubberMessage> _comments;

  String get id => this._id;
  String get avatarUrl => this._avatarUrl;
  String get name => this._name;
  int get timeStamp => this._timeStamp;

  List<BlubberMessage> get comments => this._comments;
  set comments(value) => this._comments = value;

  BlubberThread.fromMap(Map<String, dynamic> data) {
    _id = data["thread_id"];
    _avatarUrl = data["avatar"];
    _name = data["name"];
    _timeStamp = data["timestamp"];
  }

  BlubberThread.empty(String name) {
    _name = name;
    _comments = <BlubberMessage>[];
  }
}
