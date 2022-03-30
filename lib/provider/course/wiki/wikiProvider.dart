import 'dart:convert';

import 'package:compound/net/webClient.dart';
import 'package:compound/provider/course/wiki/wikiModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class WikiProvider extends ChangeNotifier {
  //courseID -> keyword1 -> Page content
  //         -> keyword2 -> Page content
  //         ...
  Map<String, Map<String, WikiPageModel>> _pages = {};
  final WebClient _client = WebClient();

  Future<Map<String, WikiPageModel>> getPages(String courseID) async {
    if (!_pages.containsKey(courseID)) {
      return forceUpdatePages(courseID);
    }
    return Future<Map<String, WikiPageModel>>.value(_pages[courseID]);
  }

  Future<Map<String, WikiPageModel>> forceUpdatePages(String courseID) async {
    Response response = await _client.httpGet("/course/$courseID/wiki", APIType.REST);

    if (response.statusCode != 200) {
      return Future.error({"reason": response.reasonPhrase, "route": "/course/:course_id/wiki"});
    }

    Map<String, dynamic> data = jsonDecode(response.body)["collection"];

    Map<String, WikiPageModel> pages = {};

    data.forEach((String url, dynamic pageData) {
      WikiPageModel page = WikiPageModel.descriptorFromMap(pageData);
      pages[page.keyword] = page;
    });

    _pages[courseID] = pages;

    notifyListeners();
    return Future<Map<String, WikiPageModel>>.value(pages);
  }

  Future<WikiPageModel> getPage(String courseID, String pageName) async {
    if (!_pages.containsKey(courseID)) {
      try {
        await forceUpdatePages(courseID);
      } catch (error) {
        return Future.error(error);
      }
    }

    WikiPageModel page = _pages[courseID][pageName];
    if (!page.contentLoaded()) {
      return _forceUpdatePage(courseID, page);
    }
    return Future<WikiPageModel>.value(page);
  }

  Future<WikiPageModel> _forceUpdatePage(String courseID, WikiPageModel page) async {
    String pageName = page.keyword;
    Response response = await _client.httpGet("/course/$courseID/wiki/$pageName", APIType.REST);

    if (response.statusCode != 200) {
      return Future.error({"error": response.reasonPhrase, "route": "/course/:course_id/wiki/:keyword"});
    }

    Map<String, dynamic> data = jsonDecode(response.body);

    _pages[courseID][page.keyword] = WikiPageModel.fromMap(data);

    notifyListeners();
    return Future<WikiPageModel>.value(_pages[courseID][page.keyword]);
  }

  void forceUpdate(String courseID, String pageName) async {
    await forceUpdatePages(courseID);
    await _forceUpdatePage(courseID, _pages[courseID][pageName]);
  }
}
