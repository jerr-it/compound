import 'dart:convert';

import 'package:fludip/net/webClient.dart';
import 'package:fludip/provider/messages/messageModel.dart';
import 'package:fludip/provider/user/userModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

///Provides the logged in users messages indentified by their id
class MessageProvider extends ChangeNotifier {
  final WebClient _client = WebClient();
  List<Message> _messages;

  bool initialized() {
    return _messages != null;
  }

  Future<List<Message>> get(String userID) async {
    if (!initialized()) {
      return forceUpdate(userID);
    }

    return Future<List<Message>>.value(_messages);
  }

  Future<List<Message>> forceUpdate(String userID) async {
    Response res = await _client.httpGet("/user/$userID/inbox");

    try {
      Map<String, dynamic> data = jsonDecode(res.body)["collection"];

      List<Message> messages = <Message>[];
      await Future.forEach(data.keys, (messageIdUrl) async {
        Map<String, dynamic> messageData = data[messageIdUrl];

        String route = messageData["sender"].toString().split("api.php")[1];
        res = await _client.httpGet(route);
        Map<String, dynamic> senderData = jsonDecode(res.body);

        User sender = User.fromMap(senderData);
        messages.add(Message.fromMap(messageData, sender));
      });

      _messages = messages;
    } catch (e) {}

    notifyListeners();
    return Future<List<Message>>.value(_messages);
  }

  void markMessageRead(String msgID) {
    _client.httpPut(
      "/message/$msgID",
      body: <String, String>{"unread": "0"},
    );
  }

  void deleteMessage(String msgID) {
    _client.httpDelete("/message/$msgID");
  }
}
