import 'dart:convert';

import 'package:compound/net/webClient.dart';
import 'package:compound/provider/course/members/memberModel.dart';
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

///Maps course ids to member lists
class MembersProvider extends ChangeNotifier {
  Map<String, Members> _members;
  final WebClient _client = WebClient();

  bool initialized(String courseID) {
    return _members != null && _members[courseID] != null;
  }

  Future<Members> get(String courseID) {
    if (!initialized(courseID)) {
      return forceUpdate(courseID);
    }
    return Future<Members>.value(_members[courseID]);
  }

  Future<Members> forceUpdate(String courseID) async {
    _members ??= <String, Members>{};

    List<User> lecturers = await _getUserList(courseID, "dozent");
    List<User> tutors = await _getUserList(courseID, "tutor");
    List<User> students = await _getUserList(courseID, "autor");

    _members[courseID] = Members.from(lecturers, tutors, students);

    notifyListeners();
    return Future<Members>.value(_members[courseID]);
  }

  Future<List<User>> _getUserList(String courseID, String status) async {
    String route = "/course/$courseID/members";
    Response res = await _client.httpGet(route, APIType.REST, urlParams: {"status": status});

    try {
      Map<String, dynamic> decoded = jsonDecode(res.body)["collection"];
      List<User> users = <User>[];
      decoded.forEach((userKey, userData) {
        users.add(User.fromMap(userData["member"]));
      });

      return Future<List<User>>.value(users);
    } catch (e) {
      return Future<List<User>>.value(<User>[]);
    }
  }

  void resetCache() {
    _members = null;
  }
}
