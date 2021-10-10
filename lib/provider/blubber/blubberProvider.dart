import 'dart:convert';

import 'package:compound/net/webClient.dart';
import 'package:compound/provider/blubber/blubberMessageModel.dart';
import 'package:compound/provider/blubber/blubberThreadModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

// Compound - Mobile StudIP client
// Copyright (C) 2021 Jerrit Gläsker

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

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

  ///Fetches all available blubber threads.
  ///Uses cache if possible.
  Future<List<BlubberThread>> getOverview() {
    if (!initialized()) {
      return forceUpdateOverview();
    }

    return Future<List<BlubberThread>>.value(_threads.values.toList());
  }

  ///Forces blubber thread overview update.
  ///Overwrites cache with new data.
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

  ///Get a specific blubber thread([name]).
  ///Uses cache if available.
  Future<BlubberThread> getThread(String name) {
    if (!threadInitialized(name)) {
      return forceUpdateThread(name);
    }

    return Future<BlubberThread>.value(_threads[name]);
  }

  ///Forces an update of a specific thread([name]).
  ///Updates cache.
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

  ///Post a user [message] to [threadID].
  void postMessage(String threadID, String message) {
    _client.httpPost(
      "/blubber/threads/$threadID/comments",
      APIType.REST,
      body: <String, String>{"content": message},
    );
  }

  ///Resets the providers internal storage.
  ///Used when the user logs out.
  void resetCache() {
    _threads = null;
  }
}
