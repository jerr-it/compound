import 'package:flutter/material.dart';

///Saves the logged in users data as returned by /users/me
class User extends ChangeNotifier {
  Map<String, dynamic> _data;

  void setData(Map<String, dynamic> data){
    _data = data;
    notifyListeners();
  }

  Map<String, dynamic> getData(){
    return _data;
  }
}