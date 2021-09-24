import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:fludip/net/webClient.dart';
import 'package:fludip/provider/user/userModel.dart';

///Saves the logged in users data as returned by /users/me
class UserProvider extends ChangeNotifier {
  User _user;
  final WebClient _client = WebClient();

  Future<User> get() async {
    if (_user == null) {
      return forceUpdate();
    }
    return Future<User>.value(_user);
  }

  Future<User> forceUpdate() async {
    var result = await _client.httpGet("/user", APIType.REST);
    Map<String, dynamic> decoded = jsonDecode(result.body);

    _user = User.fromMap(decoded);

    notifyListeners();
    return Future<User>.value(_user);
  }
}
