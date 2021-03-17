import 'package:fludip/net/webclient.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class CoursesProvider extends ChangeNotifier {
  Map<String,dynamic> _data;
  final WebClient _client = WebClient();
  String _userID;
  
  void setUserID(String userID){
    _userID = userID;
  }
  
  bool initialized(){
    return _data != null;
  }

  ///Small helper for _fillLinks
  Future<Map<String, dynamic>> _gatherLink(String route) async {
    if(route == null){
      return Future<Map<String, dynamic>>.value(null);
    }
    route = route.replaceFirst("/api.php", "").replaceFirst("/studip", "");
    return await _client.getRoute(route);
  }

  ///Fills up links inside a course with their respective data
  ///For example replaces start_semester with the data returned from
  /// /semester/:semester_id
  /// Inserts announcements under the key "announcements"
  /// Inserts forum under "modules""forum"
  Future<void> _fillLinks() async {
    Map<String,dynamic> coursesJSON = _data["collection"];


    await Future.forEach(coursesJSON.keys, (courseKey) async {
      var announcementData = await _client.getRoute("/course/" + courseKey.toString().split("/").last + "/news");
      _data["collection"][courseKey]["announcements"] = announcementData;

      String route = _data["collection"][courseKey]["start_semester"];
      var data = await _gatherLink(route);
      _data["collection"][courseKey]["start_semester"] = data;

      route = _data["collection"][courseKey]["end_semester"];
      data = await _gatherLink(route);
      _data["collection"][courseKey]["end_semester"] = data;

      route = _data["collection"][courseKey]["modules"]["forum"];
      data = await _gatherLink(route);
      _data["collection"][courseKey]["modules"]["forum"] = data;
    });

    return Future<void>.value(null);
  }

  void update() async {
    if (_data == null){
      _data = Map<String,dynamic>();
    }

    _data = await _client.getRoute("/user/" + _userID + "/courses");
    await _fillLinks();

    notifyListeners();
  }

  Map<String,dynamic> getData(){
    return _data;
  }
}