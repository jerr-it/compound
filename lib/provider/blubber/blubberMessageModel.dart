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

class BlubberMessage {
  String _userName;
  String _content;

  int _mkdate;
  int _chdate;

  String _avatarUrl;
  bool _isMine;

  get userName => this._userName;
  get content => this._content;

  get mkdate => this._mkdate;
  get chdate => this._chdate;

  get avatarUrl => this._avatarUrl;
  get isMine => this._isMine;

  BlubberMessage.fromMap(Map<String, dynamic> data) {
    _userName = data["user_name"];
    _content = data["content"];

    _mkdate = data["mkdate"];
    _chdate = data["chdate"];

    _avatarUrl = data["avatar"];
    _isMine = data["class"] == "mine" ? true : false;
  }
}
