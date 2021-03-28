import 'dart:convert';

import 'package:fludip/net/webClient.dart';
import 'package:fludip/provider/user/userModel.dart';
import 'package:flutter/material.dart';

///Saves the logged in users data as returned by /users/me
class UserProvider extends ChangeNotifier {
  User _user;
  final WebClient _client = WebClient();

  void fetch() async {
    var result = await _client.httpGet("/user");
    Map<String, dynamic> decoded = jsonDecode(result.body);

    _user = User.fromMap(decoded);

    notifyListeners();
  }

  User getData() {
    return _user;
  }
}
