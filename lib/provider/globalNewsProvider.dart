import 'package:fludip/net/webClient.dart';
import 'package:flutter/material.dart';

///Keeps all news organized in a map
///The key to each is the route by which they were retrieved
class GlobalNewsProvider extends ChangeNotifier {
  Map<String, dynamic> _data;
  final WebClient _client = WebClient();

  bool initialized() {
    return _data != null;
  }

  void update() async {
    if (_data == null) {
      _data = Map<String, dynamic>();
    }

    _data = await _client.getRoute("/studip/news");
    notifyListeners();
  }

  Map<String, dynamic> get() {
    return _data;
  }
}
