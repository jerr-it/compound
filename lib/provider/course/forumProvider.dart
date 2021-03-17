import 'package:flutter/material.dart';
import 'package:fludip/net/webClient.dart';

///Provides forum data for all the users courses.
///They are identified by their course ID.
///Forum is structured as Category > Area > Entry
///values beginning with ':' indicate a concrete value:
///TODO add forum entries (/forum_entry/:entry_id).
///ForumProvider
///|-courseID1
///  |-collection                   <- provided by /course/:course_id/forum_categories
///    |-:category_id_url
///      |-entry_name: "Allgemein"
///      |-pos: "0"
///      |-areas_count: 1
///      |-seminar_id: "fjan848f.."
///      |-areas                    <- inserted using /forum_category/:category_id/areas
///      |  |-collection
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
///      |-category_id: "afgr81r..."
///      |-course: "/api.php/..."
class ForumProvider extends ChangeNotifier{
  Map<String, Map<String,dynamic>> _data;
  final WebClient _client = WebClient();

  bool initialized(){
    return _data != null;
  }

  void update(String courseID) async {
    if(_data == null){
      _data = Map<String, Map<String,dynamic>>();
    }

    Map<String,dynamic> courseForumCategories = await _client.getRoute("/course/" + courseID + "/forum_categories");
    _data[courseID] = courseForumCategories;

    Map<String, dynamic> categoriesMap = courseForumCategories["collection"];
    var categoryKeys = categoriesMap.keys;

    await Future.forEach(categoryKeys, (categoryKey) async {
      String categoryID = categoriesMap[categoryKey]["category_id"];
      String route = "/forum_category/" + categoryID + "/areas";

      var areaData = await _client.getRoute(route);
      _data[courseID]["collection"][categoryKey]["areas"] = areaData;
    });

    debugPrint(_data.toString(), wrapWidth:1024);

    notifyListeners();
  }

  Map<String,dynamic> getData(String courseID){
    return _data[courseID];
  }
}