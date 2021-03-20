import 'package:fludip/net/webClient.dart';
import 'package:flutter/material.dart';

///Maps course ids to member lists
///MembersProvider
/// |-course_id{}
///   |-dozent{}    <- provided by /api.php/course/:course_id/members?status=dozent
///     |-:user_id_url{}
///       |-member{}
///         |-href: "api.php/..."
///         |-avatar_small: "https://..."
///         |-avatar_normal: "https://..."
///         |-avatar_small: "https://..."
///         |-id: "894ufjm13..."
///         |-avatar_original: "https://..."
///         |-name{}
///           |-given: "testaccount"
///           |-family: "Dozent"
///           |-suffix: ""
///           |-username: "test_dozent
///           |-prefix: ""
///           |-formatted: "Testaccount Dozent"
///   |-tutor{}     <- provided by /api.php/course/:course_id/members?status=tutor
///   |-autor{}     <- provided by /api.php/course/:course_idi/members?status=autor
class MembersProvider extends ChangeNotifier {
  Map<String, Map<String, dynamic>> _members;
  final WebClient _client = WebClient();

  bool initialized(String courseID) {
    return _members != null && _members[courseID] != null;
  }

  Map<String, dynamic> getMembers(String courseID) {
    try {
      return _members[courseID];
    } catch (e) {
      return null;
    }
  }

  void update(String courseID) async {
    _members ??= new Map<String, Map<String, dynamic>>();

    _members[courseID] = new Map<String, dynamic>();

    Map<String, dynamic> dozentMap = await _client.getRoute("/course/" + courseID + "/members?status=dozent");
    if (dozentMap["pagination"]["total"] != 0) {
      _members[courseID]["dozent"] = dozentMap["collection"];
    }

    Map<String, dynamic> tutorMap = await _client.getRoute("/course/" + courseID + "/members?status=tutor");
    if (tutorMap["pagination"]["total"] != 0) {
      _members[courseID]["tutor"] = tutorMap["collection"];
    }

    Map<String, dynamic> autorMap = await _client.getRoute("/course/" + courseID + "/members?status=autor");
    if (autorMap["pagination"]["total"] != 0) {
      _members[courseID]["autor"] = autorMap["collection"];
    }

    notifyListeners();
  }
}
