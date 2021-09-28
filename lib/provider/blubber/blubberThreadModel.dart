import 'package:fludip/provider/blubber/blubberMessageModel.dart';

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
