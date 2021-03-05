import 'dart:convert';

import 'package:fludip/net/webclient.dart';
import 'package:flutter/services.dart';

/// FakeClient, on the outside, behaves like a WebClient
/// but doesn't actually connect anywhere, its returns predefined data
/// to test the behaviour of the rest of the app until a proper web client
/// can be set up
class FakeClient{
  static final FakeClient _client = FakeClient._internal();
  FakeClient._internal();

  factory FakeClient() {
    return _client;
  }

  void init(String path) async {
    var data = await rootBundle.loadString(path);
    _fakeData = jsonDecode(data);
    print(_fakeData);
  }

  Server _server;
  void setServer(Server server) => this._server = server;

  Map<String,dynamic> _fakeData;

  Future<String> doRoute(String route) {
    if (this._server == null || this._fakeData == null){
      return Future<String>.value(null);
    }

    return Future<String>.value(jsonEncode(_fakeData[route]));
  }
}