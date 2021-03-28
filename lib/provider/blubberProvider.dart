import 'package:fludip/net/webClient.dart';
import 'package:flutter/material.dart';

///Maps threads to their comments
///Threads are identified by their name
///|-:thread_name
///  |-thread_posting{}
///  |-context_info
///  |-comments[]
///  | |-[0]
///  |   |-comment_id: "98fd43982..."
///  |   |-thread_id: "89dj1398rr8r..."
///  |   |-user_id: "89j398jfd8j2423..."
///  |   |-external_contact: "0"
///  |   |-content: "this is an example blubber message"
///  |   |-network: ""
///  |   |-chdate: 1247985137
///  |   |-mkdate: 1209398754
///  |   |-avatar: "https:..."
///  |   |-user_name: "Testaccount Autor"
///  |   |-user_username: "test_autor"
///  |   |-class: "mine" (/"theirs")
///  |   |-html: "<div..."
///  |   |-writable: true
///  |-more_up
///  |-more_down
///  |-unseen_comments: 0
class BlubberProvider extends ChangeNotifier {
  Map<String, dynamic> _data;
  List<dynamic> _threads;

  final WebClient _client = WebClient();

  bool initialized() {
    return _data != null;
  }

  bool threadInitialized(String name) {
    return _data[name] != null;
  }

  Future<void> fetchOverview() async {
    print("OVERVIEW");

    _data ??= <String, dynamic>{};
    _threads ??= <dynamic>[];

    var res = await _client.getRoute("/blubber/threads");
    _threads = res["threads"];

    notifyListeners();
  }

  Future<void> fetchThread(String name) async {
    print("THREAD");

    var threadObject = _threads.firstWhere((thread) => thread["name"] == name);
    String threadID = threadObject["thread_id"];

    var threadContent = await _client.getRoute("/blubber/threads/$threadID");
    _data[name] = threadContent;

    notifyListeners();
  }

  List<dynamic> getThreads() {
    return _threads;
  }

  Map<String, dynamic> getThread(String name) {
    return _data[name];
  }
}
