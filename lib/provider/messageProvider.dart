import 'package:fludip/net/webClient.dart';
import 'package:flutter/material.dart';

///Provides the logged in users messages indentified by their id
///user/:user_id/:box
///|-:message_id_url
///  |-message_id: "f89028jf..."
///  |-subject: "test subject"
///  |-message: "test message body"
///  |-mkdate: "1616688524"
///  |-priority: "normal"
///  |-message_html: "<div..."
///  |-tags: []
///  |-sender: "/studip/api.php/user/981209i..."
///  |-recipients[]
///  | |-"/studip/api.php/user/839j1..."
///  |-unread: false
class MessageProvider extends ChangeNotifier {
  final WebClient _client = WebClient();
  Map<String, dynamic> _data;
  String _userID;

  void setUserID(String id) {
    _userID = id;
  }

  bool initialized() {
    return _data != null;
  }

  void update() async {
    var res = await _client.getRoute("/user/$_userID/inbox");
    _data = res["collection"];

    await Future.forEach(_data.keys, (messageIdUrl) async {
      Map<String, dynamic> messageData = _data[messageIdUrl];

      String route = messageData["sender"].toString().split("api.php")[1];
      var senderData = await _client.getRoute(route);

      _data[messageIdUrl]["sender"] = senderData;
    });

    notifyListeners();
  }

  Map<String, dynamic> get() {
    return _data;
  }
}
