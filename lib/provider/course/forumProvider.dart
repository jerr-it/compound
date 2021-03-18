import 'package:flutter/material.dart';
import 'package:fludip/net/webClient.dart';

///Provides forum data for all the users courses.
///They are identified by their course ID.
///Forum is structured as Category > Area > Topic > Entry
///values beginning with ':' indicate a concrete value:
///TODO add forum entries (/forum_entry/:entry_id).
///ForumProvider
///|-courseID1{}
///  |-collection{}                   <- provided by /course/:course_id/forum_categories
///    |-:category_id_url
///      |-entry_name: "Allgemein"
///      |-pos: "0"
///      |-areas_count: 1
///      |-seminar_id: "fjan848f.."
///      |-areas{}                    <- inserted using /forum_category/:category_id/areas
///      |  |-collection{}
///      |    |-:area_id_url
///      |      |-course: "/api.php/..."
///      |      |-depth: "1"
///      |      |-content: "Hier ist Raum für allgemeine Diskussion"
///      |      |-topic_id: "jakj8fu482jlkfj..."
///      |      |-subject: "Allgemeine Diskussion"
///      |      |-content_html: "<div..."
///      |      |-user: "/api.php/user/..."
///      |      |-anonymous: "0"
///      |      |-mkdate: "1477315889"
///      |      |-chdate: "1477315889"
///      |      |-topics[]          <- inserted using /forum_entry/:topic_id ["children"]
///      |        |-content_html: "<div..."
///      |        |-subject : "<div class=\"formatted-content\">Test-Thema</div>",
///      |        |-chdate: "1477316401"
///      |        |-user: "/api.php/user/..."
///      |        |-topic_id:"a87fzu879..."
///      |        |-anonymous: "0",
///      |        |-depth: "2"
///      |        |-mkdate: "1477316401"
///      |        |-content: "<div class=\"formatted-content\">Test-Inhalt des Test-Themas.</div>"  #Also contains html for some reason
///      |        |-course: "/api.php/course/..."
///      |-category_id: "afgr81r..."
///      |-course: "/api.php/..."
class ForumProvider extends ChangeNotifier{
  Map<String, Map<String,dynamic>> _data;
  final WebClient _client = WebClient();

  bool initialized(String courseID){
    return _data != null && _data[courseID] != null;
  }

  void update(String courseID) async {
    _data ??= Map<String, Map<String,dynamic>>();

    Map<String,dynamic> courseForumCategories = await _client.getRoute("/course/" + courseID + "/forum_categories");
    _data[courseID] = courseForumCategories;

    try {
      Map<String, dynamic> categoriesMap = courseForumCategories["collection"];
      var categoryKeys = categoriesMap.keys;

      await Future.forEach(categoryKeys, (categoryKey) async {
        //Iterate categories and add areas
        String categoryID = categoriesMap[categoryKey]["category_id"];
        String route = "/forum_category/" + categoryID + "/areas";

        var areaData = await _client.getRoute(route);
        _data[courseID]["collection"][categoryKey]["areas"] = areaData;
      });
    }catch(e){
      print("Collection empty: " + e.toString());
    }

    notifyListeners();
  }

  List<dynamic> getTopicsMap(String courseID, String categoryIDUrl, String areaIDUrl){
    try {
      return _data[courseID]["collection"][categoryIDUrl]["areas"]["collection"][areaIDUrl]["topics"];
    }catch(e){
      return null;
    }
  }

  void loadAreaTopics(String courseID, String categoryIDUrl, String areaIDUrl) async {
    _data ??= Map<String, Map<String,dynamic>>();


    Map<String,dynamic> areaMap = _data[courseID]["collection"][categoryIDUrl]["areas"]["collection"][areaIDUrl];

    String topicID = areaMap["topic_id"];
    Map<String, dynamic> areaData = await _client.getRoute("/forum_entry/" + topicID);

    _data[courseID]["collection"][categoryIDUrl]["areas"]["collection"][areaIDUrl]["topics"] ??= <dynamic>[];
    //_data[courseID]["collection"][categoryIDUrl]["areas"]["collection"][areaIDUrl]["topics"].clear();
    _data[courseID]["collection"][categoryIDUrl]["areas"]["collection"][areaIDUrl]["topics"].addAll(areaData["children"]);

    notifyListeners();
  }

  Map<String,dynamic> getData(String courseID){
    try {
      return _data[courseID];
    }catch(e){
      return null;
    }
  }
}