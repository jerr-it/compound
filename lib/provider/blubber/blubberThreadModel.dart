import 'package:fludip/provider/blubber/blubberMessageModel.dart';

class BlubberThread {
  int _unseenCount;
  List<BlubberMessage> _comments;

  get unseenCount => this._unseenCount;
  List<BlubberMessage> get comments => this._comments;
  set comments(List<BlubberMessage> value) => this._comments = value;

  BlubberThread.fromMap(Map<String, dynamic> data) {
    _unseenCount = data["unseen_comments"];
  }
}
