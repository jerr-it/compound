import 'package:fludip/net/webClient.dart';
import 'package:flutter/material.dart';
import 'dart:async';

///This provider provides the data for the courses themselves *and* the overview tab
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
  Future<void> _fillLinks() async {
    Map<String,dynamic> coursesJSON = _data["collection"];


    await Future.forEach(coursesJSON.keys, (courseKey) async {
      //Announcements
      var announcementData = await _client.getRoute("/course/" + courseKey.toString().split("/").last + "/news");
      _data["collection"][courseKey]["announcements"] = announcementData;

      //Semester start date
      String route = _data["collection"][courseKey]["start_semester"];
      var data = await _gatherLink(route);
      _data["collection"][courseKey]["start_semester"] = data;

      //Semester end date
      route = _data["collection"][courseKey]["end_semester"];
      data = await _gatherLink(route);
      _data["collection"][courseKey]["end_semester"] = data;
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