import 'package:compound/provider/user/userModel.dart';

class WikiPageModel {
  String _rangeID;
  String _keyword;

  int _chdate;
  int _version;

  String _content;
  String _contentHtml;

  User _user;

  String get rangeID => this._rangeID;
  String get keyword => this._keyword;

  int get chdate => this._chdate;
  int get version => this._version;

  String get content => this._content;
  String get contentHtml => this._contentHtml;

  User get author => this._user;
  set(User user) => this._user = user;

  bool contentLoaded() {
    return content != null;
  }

  WikiPageModel.descriptorFromMap(Map<String, dynamic> data) {
    _keyword = data["keyword"];
    try {
      _version = data["version"];
    } catch (_) {
      _version = int.parse(data["version"]);
    } finally {
      _version = 0;
    }
  }

  WikiPageModel.fromMap(Map<String, dynamic> data) {
    _rangeID = data["rangeID"];
    _keyword = data["keyword"];

    _chdate = int.parse(data["chdate"]);
    _version = int.parse(data["version"]);

    _content = data["content"];
    _contentHtml = data["contentHtml"];
  }
}
