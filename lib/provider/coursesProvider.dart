import 'package:fludip/net/webClient.dart';
import 'package:flutter/material.dart';
import 'dart:async';

///This provider provides the data for the courses themselves *and* the overview tab
///As provided by /user/:user_id/courses
///Structure if internal _data map
///values beginning with ':' indicate a concrete value:
///a course_id_url for example could be: "/api.php/course/984e34196f2e6ea6e1b2cc58f432fb8d"
///|-collection
///  |-:course_id_url
///    |-course_id: "1874n5oi1j38..."
///    |-title: "Testveranstaltung"
///    |-subtitle: "eine normale Lehrveranstaltung"
///    |-description: "Sehr nützliche Beschreibung dieses Kurses"
///    |-type: "1",
///    |-group: 6
///    |-number: "31845"
///    |-location: "Somewhere xy"
///    |-start_semester <- content from /semester/:semester_id
///    | |-title: "SS 2020"
///    | |-begin: 1459461600,
///    | |-end: 1475272799,
///    | |-seminars_begin: 1460325600
///    | |-seminars_end: 1468619999
///    | |-id: "falsgesfkjefijietr859834"
///    | |-description:"semester description"
///    |-end_semester: <- content from /semester/:semester_id
///    | |-title: "SS 2020"
///    | |-begin: 1459461600,
///    | |-end: 1475272799,
///    | |-seminars_begin: 1460325600
///    | |-seminars_end: 1468619999
///    | |-id: "fafsflskjefijietr859834"
///    | |-description:"semester description"
///    |-announcements <- inserted, content from /course/:course_id/news
///    | |-collection
///    |   |-:news_id_url
///    |     |-expire: "691140"
///    |     |-chdate_uid: "",
///    |     |-topic: "Ausfall der Veranstaltung"
///    |     |-ranges
///    |     | |-"/api.php/course/a07535cf2f8a72df33c12ddfa4b53dde/news"
///    |     |-user_id: "kjfaoij4824f..."
///    |     |-date: "1478818800"
///    |     |-chdate: "1478818800"
///    |     |-mkdate: "1478818800"
///    |     |-news_id: "d8d92fb84dbb1150f09199f923c54aa8"
///    |     |-body: "Die Veranstaltung fällt am xy aus"
///    |     |-body_html: "<div..."
///    |     |-allow_comments: "0"
///    |-lecturers
///    | |-:lecturer_id_url
///    |   |-name
///    |   | |-given: "testaccount"
///    |   | |-formatted: "Testaccount Dozent"
///    |   | |-suffix: "",
///    |   | |-family: "Dozent",
///    |   | |-username: "test_dozent",
///    |   | |-prefix: ""
///    |   |-avatar_small: "https://..."
///    |   |-avatar_medium: "https://..."
///    |   |-avatar_normal: "https://..."
///    |   |-href: "/api.php/user/..."
///    |   |-avatar_original: "https://..."
///    |   |-id: "3892174jdj183nvv..."
///    |-members
///    | |-user: "/api.php/course/:course_id/members?status=user"
///    | |-user_count: 0
///    | |-autor: "/api.php/course/:course_id/members?status=autor"
///    | |-autor_count: 0
///    | |-dozent: "/api.php/course/:course_id/members?status=dozent"
///    | |-dozent_count: 1
///    |-modules
///    | |-documents: "/api.php/course/:course_id/files"
///    | |-wiki: "/api.php/course/:course_id/wiki
///    | |-forum: "/api.php/course/:course_id/forum_categories
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
  ///as described at the top of the file
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