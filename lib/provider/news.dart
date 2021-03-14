import 'package:flutter/material.dart';

///Keeps all news organized in a map
///The key to each is the route by which they were retrieved
class NewsProvider extends ChangeNotifier{
  Map<String, Map<String, dynamic>> _data;

  void setNews(String route, Map<String, dynamic> data){
    if (_data == null){
      _data = Map<String, Map<String, dynamic>>();
    }

    _data[route] = data;
    notifyListeners();
  }

  Map<String, dynamic> getNews(String route) {
    return _data[route];
  }
}