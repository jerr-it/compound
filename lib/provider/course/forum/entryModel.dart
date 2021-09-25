import 'package:fludip/provider/user/userModel.dart';

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
