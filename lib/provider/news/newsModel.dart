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

///Abstracts StudIP news data
class News {
  String _topic;
  String _body;
  String _bodyHTML;

  String _userID;
  String _newsID;

  String _commentsUrl;

  int _date;
  int _chdate;
  int _mkdate;
  int _expire;

  bool _allowComments;
  int _commentCount;

  String get topic => this._topic;
  String get body => this._body;
  String get bodyHTML => this._bodyHTML;

  String get userID => this._userID;
  String get newsID => this._newsID;

  String get commentsUrl => this._commentsUrl;

  int get date => this._date;
  int get chdate => this._chdate;
  int get mkdate => this._mkdate;
  int get expire => this._expire;

  bool get allowComments => this._allowComments;
  int get commentCount => this._commentCount;

  News.fromMap(Map<String, dynamic> data) {
    _topic = data["topic"];
    _body = data["body"];
    _bodyHTML = data["body_html"];

    _userID = data["user_id"];
    _newsID = data["news_id"];

    _commentsUrl = data["comments"];

    _date = int.parse(data["date"]) * 1000;
    _chdate = int.parse(data["chdate"]) * 1000;
    _mkdate = int.parse(data["mkdate"]) * 1000;
    _expire = int.parse(data["expire"]) * 1000;

    _allowComments = data["allow_comments"] == "0" ? false : true;
    _commentCount = data["comments_count"];
  }
}
