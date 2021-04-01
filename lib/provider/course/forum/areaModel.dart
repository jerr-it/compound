import 'package:fludip/provider/course/forum/topicModel.dart';

class ForumArea {
  String _id;

  String _subject;
  String _content;
  String _contentHTML;

  int _mkdate;
  int _chdate;

  String _anonymous;
  String _depth;

  List<ForumTopic> _topics;

  String get id => this._id;

  String get subject => this._subject;
  String get content => this._content;
  String get contentHTML => this._contentHTML;

  int get mkdate => this._mkdate;
  int get chdate => this._chdate;

  String get anonymous => this._anonymous;
  String get depth => this._depth;

  List<ForumTopic> get topics => this._topics;
  set topics(value) => this._topics = value;

  ForumArea.fromMap(Map<String, dynamic> data) {
    _id = data["topic_id"];

    _subject = data["subject"];
    _content = data["content"];
    _contentHTML = data["content_html"];

    _mkdate = int.parse(data["mkdate"]);
    _chdate = int.parse(data["chdate"]);

    _anonymous = data["anonymous"];
    _depth = data["depth"];
  }
}
