import 'package:flutter/material.dart';

class EventProvider extends ChangeNotifier {
  Map<String,dynamic> _data;

  bool initialized(){
    return _data != null;
  }

  void setData(Map<String,dynamic> data){
    if (_data == null){
      _data = Map<String,dynamic>();
    }

    _data = data;
    notifyListeners();
  }

  Map<String,dynamic> getData(){
    return _data;
  }
}