import 'package:fludip/provider/user/userModel.dart';

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

  get id => this._id;

  get subject => this._subject;
  get content => this._content;
  get contentHTML => this._contentHTML;

  get mkdate => this._mkdate;
  get priority => this._priority;
  get read => this._read;
  get tags => this._tags;

  get sender => this._sender;

  Message.fromMap(Map<String, dynamic> data, User sender) {
    _id = data["message_id"];

    _subject = data["subject"];
    _content = data["message"];
    _contentHTML = data["message_html"];

    _mkdate = int.parse(data["mkdate"]);
    _priority = data["priority"];
    _read = !data["unread"];
    _tags = data["tags"];

    _sender = sender;
  }
}
