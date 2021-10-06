import 'dart:convert';

import 'package:fludip/net/webClient.dart';
import 'package:fludip/provider/course/forum/areaModel.dart';
import 'package:fludip/provider/course/forum/categoryModel.dart';
import 'package:fludip/provider/course/forum/entryModel.dart';
import 'package:fludip/provider/course/forum/topicModel.dart';
import 'package:fludip/provider/user/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

///Provides forum data for all the users courses.
///They are identified by their course ID.
///Forum is structured as Category > Area > Topic > Entry
class ForumProvider extends ChangeNotifier {
  Map<String, List<ForumCategory>> _forums;
  final WebClient _client = WebClient();

  bool initialized(String courseID) {
    return _forums != null && _forums[courseID] != null;
  }

  ///--------------------------------///
  ///Category                        ///
  ///--------------------------------///

  Future<List<ForumCategory>> getCategories(String courseID) {
    if (!initialized(courseID)) {
      return forceUpdateCategories(courseID);
    }

    return Future<List<ForumCategory>>.value(_forums[courseID]);
  }

  Future<List<ForumCategory>> forceUpdateCategories(String courseID) async {
    _forums ??= <String, List<ForumCategory>>{};

    List<ForumCategory> categories = <ForumCategory>[];

    Response res = await _client.httpGet("/course/$courseID/forum_categories", APIType.REST);

    try {
      Map<String, dynamic> decoded = jsonDecode(res.body)["collection"];

      decoded.forEach((categoryKey, categoryData) {
        ForumCategory category = ForumCategory.fromMap(categoryData);
        categories.add(category);
      });

      _forums[courseID] = categories;

      for (int i = 0; i < _forums[courseID].length; i++) {
        await forceUpdateAreas(courseID, i);
      }
    } catch (e) {
      _forums[courseID] = <ForumCategory>[];
    }

    notifyListeners();
    return Future<List<ForumCategory>>.value(_forums[courseID]);
  }

  ///--------------------------------///
  ///Area                            ///
  ///--------------------------------///

  Future<List<ForumArea>> getAreas(String courseID, int categoryIdx) {
    if (_forums[courseID][categoryIdx].areas == null) {
      return forceUpdateAreas(courseID, categoryIdx);
    }

    ForumCategory selectedCategory = _forums[courseID][categoryIdx];
    return Future<List<ForumArea>>.value(selectedCategory.areas);
  }

  Future<List<ForumArea>> forceUpdateAreas(String courseID, int categoryIdx) async {
    ForumCategory selectedCategory = _forums[courseID][categoryIdx];

    String categoryID = selectedCategory.categoryID;
    String route = "/forum_category/$categoryID/areas";

    Response res = await _client.httpGet(route, APIType.REST);
    Map<String, dynamic> decoded = jsonDecode(res.body)["collection"];

    List<ForumArea> areas = <ForumArea>[];
    decoded.forEach((areaKey, areaData) {
      areas.add(ForumArea.fromMap(areaData));
    });

    _forums[courseID][categoryIdx].areas = areas;

    notifyListeners();
    return Future<List<ForumArea>>.value(_forums[courseID][categoryIdx].areas);
  }

  ///--------------------------------///
  ///Topic                           ///
  ///--------------------------------///

  Future<List<ForumTopic>> getTopics(BuildContext context, String courseID, int categoryIdx, int areaIdx) {
    if (_forums[courseID][categoryIdx].areas[areaIdx].topics == null) {
      return forceUpdateTopics(context, courseID, categoryIdx, areaIdx);
    }

    ForumArea selectedArea = _forums[courseID][categoryIdx].areas[areaIdx];
    return Future<List<ForumTopic>>.value(selectedArea.topics);
  }

  Future<List<ForumTopic>> forceUpdateTopics(BuildContext context, String courseID, int categoryIdx, int areaIdx) async {
    ForumArea selectedArea = _forums[courseID][categoryIdx].areas[areaIdx];

    String areaID = selectedArea.id;
    String route = "/forum_entry/$areaID";

    Response res = await _client.httpGet(route, APIType.REST);
    List<dynamic> decoded = jsonDecode(res.body)["children"];

    List<ForumTopic> topics = <ForumTopic>[];
    decoded.forEach((topicData) async {
      topics.add(ForumTopic.fromMap(topicData));

      String userID = topicData["user"].toString().split("/").last;
      topics.last.user = await Provider.of<UserProvider>(context, listen: false).get(userID);
    });

    _forums[courseID][categoryIdx].areas[areaIdx].topics = topics;

    notifyListeners();
    return Future<List<ForumTopic>>.value(_forums[courseID][categoryIdx].areas[areaIdx].topics);
  }

  ///--------------------------------///
  ///Entry                           ///
  ///--------------------------------///

  Future<List<ForumEntry>> getEntries(BuildContext context, String courseID, int categoryIdx, int areaIdx, int topicIdx) {
    if (_forums[courseID][categoryIdx].areas[areaIdx].topics[topicIdx].entries == null) {
      return forceUpdateEntries(context, courseID, categoryIdx, areaIdx, topicIdx);
    }

    ForumTopic selectedTopic = _forums[courseID][categoryIdx].areas[areaIdx].topics[topicIdx];
    return Future<List<ForumEntry>>.value(selectedTopic.entries);
  }

  Future<List<ForumEntry>> forceUpdateEntries(
      BuildContext context, String courseID, int categoryIdx, int areaIdx, int topicIdx) async {
    ForumTopic selectedTopic = _forums[courseID][categoryIdx].areas[areaIdx].topics[topicIdx];

    String topicID = selectedTopic.id;
    String route = "/forum_entry/$topicID";

    Response res = await _client.httpGet(route, APIType.REST);
    List<dynamic> decoded = jsonDecode(res.body)["children"];

    List<ForumEntry> entries = <ForumEntry>[];

    //Add first entry by hand, because its not provided by /forum_entry/:topic_id
    entries.add(ForumEntry.fromMap(<String, dynamic>{
      "subject": selectedTopic.subject,
      "content": selectedTopic.content,
      "chdate": selectedTopic.chdate.toString(),
      "mkdate": selectedTopic.mkdate.toString(),
      "anonymous": selectedTopic.anonymous,
      "depth": selectedTopic.depth,
    }));
    entries.last.user = await Provider.of<UserProvider>(context, listen: false).get(selectedTopic.user.userID);

    decoded.forEach((entryData) async {
      entries.add(ForumEntry.fromMap(entryData));
      String userID = entryData["user"].toString().split("/").last;
      entries.last.user = await Provider.of<UserProvider>(context, listen: false).get(userID);
    });

    _forums[courseID][categoryIdx].areas[areaIdx].topics[topicIdx].entries = entries;

    notifyListeners();
    return Future<List<ForumEntry>>.value(_forums[courseID][categoryIdx].areas[areaIdx].topics[topicIdx].entries);
  }

  Future<Response> sendReply(String courseID, int categoryIdx, int areaIdx, int topicIdx, String reply) {
    ForumTopic selectedTopic = _forums[courseID][categoryIdx].areas[areaIdx].topics[topicIdx];
    String route = "/forum-entries/" + selectedTopic.id + "/entries";

    Map<String, dynamic> body = <String, dynamic>{
      "data": <String, dynamic>{
        "type": "forum-entries",
        "attributes": <String, String>{
          "title": "",
          "content": reply,
        },
      },
    };

    return _client.httpPost(route, APIType.JSON, body: jsonEncode(body));
  }

  void resetCache() {
    _forums = null;
  }
}
