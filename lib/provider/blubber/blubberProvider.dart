import 'dart:convert';

import 'package:fludip/net/webClient.dart';
import 'package:fludip/provider/blubber/blubberMessageModel.dart';
import 'package:fludip/provider/blubber/blubberThreadModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

///Maps threads to their comments
///Threads are identified by their name
class BlubberProvider extends ChangeNotifier {
  Map<String, BlubberThread> _threads;
  final WebClient _client = WebClient();

  bool initialized() {
    return _threads != null;
  }

  bool threadInitialized(String name) {
    return _threads[name] != null && _threads[name].comments != null;
  }

  Future<List<BlubberThread>> getOverview() {
    if (!initialized()) {
      return forceUpdateOverview();
    }

    return Future<List<BlubberThread>>.value(_threads.values.toList());
  }

  Future<List<BlubberThread>> forceUpdateOverview() async {
    _threads ??= <String, BlubberThread>{};

    Response res = await _client.httpGet("/blubber/threads", APIType.REST);
    List<dynamic> threadOverview = jsonDecode(res.body)["threads"];

    threadOverview.forEach((threadData) {
      BlubberThread thread = BlubberThread.fromMap(threadData);
      _threads[threadData["name"]] = thread;
    });

    notifyListeners();
    return Future<List<BlubberThread>>.value(_threads.values.toList());
  }

  Future<BlubberThread> getThread(String name) {
    if (!threadInitialized(name)) {
      return forceUpdateThread(name);
    }

    return Future<BlubberThread>.value(_threads[name]);
  }

  Future<BlubberThread> forceUpdateThread(String name) async {
    BlubberThread thread = _threads[name];
    if (thread == null) {
      _threads[name] = BlubberThread.empty(name);
      return Future<BlubberThread>.value(_threads[name]);
    }

    String threadID = thread.id;

    Response res = await _client.httpGet("/blubber/threads/$threadID", APIType.REST);
    Map<String, dynamic> decoded = jsonDecode(res.body);
    List<dynamic> commentsList = decoded["comments"];

    List<BlubberMessage> messages = <BlubberMessage>[];
    commentsList.forEach((commentData) {
      messages.add(BlubberMessage.fromMap(commentData));
    });
    _threads[name].comments = messages;

    notifyListeners();
    return Future<BlubberThread>.value(_threads[name]);
  }

  void postMessage(String threadID, String message) {
    _client.httpPost(
      "/blubber/threads/$threadID/comments",
      APIType.REST,
      body: <String, String>{"content": message},
    );
  }

  void resetCache() {
    _threads = null;
  }
}
