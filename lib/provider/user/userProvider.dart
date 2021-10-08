import 'dart:convert';

import 'package:fludip/net/webClient.dart';
import 'package:fludip/provider/user/userModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

// Fludip - Mobile StudIP client
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
