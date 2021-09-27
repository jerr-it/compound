import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:fludip/net/webClient.dart';
import 'package:fludip/provider/user/userModel.dart';
import 'package:http/http.dart';

///Saves user data as requested by /user and /user/:user_id
class UserProvider extends ChangeNotifier {
  Map<String, User> _users = new Map();
  final WebClient _client = WebClient();

  Future<User> get(String userID) async {
    if (!_users.containsKey(userID)) {
      return forceUpdate(userID);
    }
    return Future<User>.value(_users[userID]);
  }

  Future<User> forceUpdate(String userID) async {
    Response result;
    if (userID == "self") {
      result = await _client.httpGet("/user", APIType.REST);
    } else {
      String queryStr = "/user/$userID";
      result = await _client.httpGet(queryStr, APIType.REST);
    }

    Map<String, dynamic> decoded = jsonDecode(result.body);

    _users[userID] = User.fromMap(decoded);

    notifyListeners();
    return Future<User>.value(_users[userID]);
  }

  void resetCache() {
    _users = new Map();
  }
}
