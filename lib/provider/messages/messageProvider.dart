import 'dart:convert';

import 'package:compound/net/webClient.dart';
import 'package:compound/provider/messages/messageModel.dart';
import 'package:compound/provider/user/userModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

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
    Response res = await _client.httpGet("/user/$userID/inbox", APIType.REST);

    try {
      Map<String, dynamic> data = jsonDecode(res.body)["collection"];

      List<Message> messages = <Message>[];
      await Future.forEach(data.keys, (messageIdUrl) async {
        Map<String, dynamic> messageData = data[messageIdUrl];

        String route = messageData["sender"].toString().split("api.php")[1];
        res = await _client.httpGet(route, APIType.REST);
        Map<String, dynamic> senderData = jsonDecode(res.body);

        User sender = User.fromMap(senderData);
        messages.add(Message.fromMap(messageData, sender));
      });

      _messages = messages;
    } catch (e) {}

    notifyListeners();
    return Future<List<Message>>.value(_messages);
  }

  ///Marks a given message as read
  void markMessageRead(String msgID) {
    _client.httpPut(
      "/message/$msgID",
      APIType.REST,
      body: <String, String>{"unread": "0"},
    );
  }

  ///Deletes a given message forever
  void deleteMessage(String msgID) {
    _client.httpDelete("/message/$msgID", APIType.REST);
  }

  void resetCache() {
    _messages = null;
  }
}
