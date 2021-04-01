import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:fludip/provider/course/forum/areaModel.dart';
import 'package:fludip/provider/course/forum/categoryModel.dart';
import 'package:fludip/provider/course/forum/entryModel.dart';
import 'package:fludip/provider/course/forum/topicModel.dart';
import 'package:fludip/net/webClient.dart';

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

  List<ForumCategory> getCategories(String courseID) {
    return _forums[courseID];
  }

  Future<void> updateCategories(String courseID) async {
    _forums ??= <String, List<ForumCategory>>{};

    List<ForumCategory> categories = <ForumCategory>[];

    Response res = await _client.httpGet("/course/$courseID/forum_categories");

    try {
      Map<String, dynamic> decoded = jsonDecode(res.body)["collection"];

      decoded.forEach((categoryKey, categoryData) {
        ForumCategory category = ForumCategory.fromMap(categoryData);
        categories.add(category);
      });

      _forums[courseID] = categories;

      for (int i = 0; i < _forums[courseID].length; i++) {
        await _updateAreas(courseID, i);
      }
    } catch (e) {}

    notifyListeners();
  }

  ///--------------------------------///
  ///Area                            ///
  ///--------------------------------///

  List<ForumArea> getAreas(String courseID, int categoryIdx) {
    ForumCategory selectedCategory = _forums[courseID][categoryIdx];
    return selectedCategory.areas;
  }

  Future<void> _updateAreas(String courseID, int categoryIdx) async {
    ForumCategory selectedCategory = _forums[courseID][categoryIdx];

    String categoryID = selectedCategory.categoryID;
    String route = "/forum_category/$categoryID/areas";

    Response res = await _client.httpGet(route);
    Map<String, dynamic> decoded = jsonDecode(res.body)["collection"];

    List<ForumArea> areas = <ForumArea>[];
    decoded.forEach((areaKey, areaData) {
      areas.add(ForumArea.fromMap(areaData));
    });

    _forums[courseID][categoryIdx].areas = areas;

    notifyListeners();
  }

  ///--------------------------------///
  ///Topic                           ///
  ///--------------------------------///

  List<ForumTopic> getTopics(String courseID, int categoryIdx, int areaIdx) {
    ForumArea selectedArea = _forums[courseID][categoryIdx].areas[areaIdx];
    return selectedArea.topics;
  }

  Future<void> updateTopics(String courseID, int categoryIdx, int areaIdx) async {
    ForumArea selectedArea = _forums[courseID][categoryIdx].areas[areaIdx];

    String areaID = selectedArea.id;
    String route = "/forum_entry/$areaID";

    Response res = await _client.httpGet(route);
    List<dynamic> decoded = jsonDecode(res.body)["children"];

    List<ForumTopic> topics = <ForumTopic>[];
    decoded.forEach((topicData) {
      topics.add(ForumTopic.fromMap(topicData));
    });

    _forums[courseID][categoryIdx].areas[areaIdx].topics = topics;

    notifyListeners();
  }

  ///--------------------------------///
  ///Entry                           ///
  ///--------------------------------///

  List<ForumEntry> getEntries(String courseID, int categoryIdx, int areaIdx, int topicIdx) {
    ForumTopic selectedTopic = _forums[courseID][categoryIdx].areas[areaIdx].topics[topicIdx];
    return selectedTopic.entries;
  }

  Future<void> updateEntries(String courseID, int categoryIdx, int areaIdx, int topicIdx) async {
    ForumTopic selectedTopic = _forums[courseID][categoryIdx].areas[areaIdx].topics[topicIdx];

    String topicID = selectedTopic.id;
    String route = "/forum_entry/$topicID";

    Response res = await _client.httpGet(route);
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

    decoded.forEach((entryData) {
      entries.add(ForumEntry.fromMap(entryData));
    });

    _forums[courseID][categoryIdx].areas[areaIdx].topics[topicIdx].entries = entries;

    notifyListeners();
  }
}