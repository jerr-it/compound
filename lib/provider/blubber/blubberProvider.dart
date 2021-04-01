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

  Future<void> fetchOverview() async {
    _threads ??= <String, BlubberThread>{};

    Response res = await _client.httpGet("/blubber/threads");
    List<dynamic> threadOverview = jsonDecode(res.body)["threads"];

    threadOverview.forEach((threadData) {
      BlubberThread thread = BlubberThread.fromMap(threadData);
      _threads[threadData["name"]] = thread;
    });

    notifyListeners();
  }

  Future<void> fetchThread(String name) async {
    BlubberThread thread = _threads[name];
    if (thread == null) {
      return;
    }

    String threadID = thread.id;

    Response res = await _client.httpGet("/blubber/threads/$threadID");
    Map<String, dynamic> decoded = jsonDecode(res.body);
    List<dynamic> commentsList = decoded["comments"];

    List<BlubberMessage> messages = <BlubberMessage>[];
    commentsList.forEach((commentData) {
      messages.add(BlubberMessage.fromMap(commentData));
    });
    _threads[name].comments = messages;

    notifyListeners();
  }

  List<BlubberThread> getThreads() {
    return _threads.values.toList();
  }

  BlubberThread getThread(String name) {
    return _threads[name];
  }
}
