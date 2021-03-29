import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:fludip/net/webClient.dart';
import 'package:fludip/provider/course/members/memberModel.dart';
import 'package:fludip/provider/user/userModel.dart';

///Maps course ids to member lists
class MembersProvider extends ChangeNotifier {
  Map<String, Members> _members;
  final WebClient _client = WebClient();

  bool initialized(String courseID) {
    return _members != null && _members[courseID] != null;
  }

  Members getMembers(String courseID) {
    return _members[courseID];
  }

  Future<void> update(String courseID) async {
    _members ??= <String, Members>{};

    var lecturers = await _getUserList(courseID, "dozent");
    var tutors = await _getUserList(courseID, "tutor");
    var students = await _getUserList(courseID, "autor");

    _members[courseID] = Members.from(lecturers, tutors, students);

    notifyListeners();
  }

  Future<List<User>> _getUserList(String courseID, String status) async {
    String route = "/course/$courseID/members?status=$status";
    Response res = await _client.httpGet(route);

    Map<String, dynamic> decoded = jsonDecode(res.body)["collection"];
    List<User> users = <User>[];
    decoded.forEach((userKey, userData) {
      users.add(User.fromMap(userData));
    });

    return Future<List<User>>.value(users);
  }
}
