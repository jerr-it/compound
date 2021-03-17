import 'package:fludip/net/webClient.dart';
import 'package:flutter/material.dart';

///Saves the logged in users data as returned by /users/me
class UserProvider extends ChangeNotifier {
  Map<String, dynamic> _data;
  final WebClient _client = WebClient();

  void update() async {
    _data = await _client.getRoute("/user");
    notifyListeners();
  }

  Map<String, dynamic> getData(){
    return _data;
  }
}