import 'dart:convert';

import 'package:fludip/net/server.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SavedServers {
  static final SavedServers _savedServers = SavedServers._internal();
  SavedServers._internal();

  factory SavedServers() {
    return _savedServers;
  }

  List<Server> _entries;
  List<Server> get entries => this._entries;

  Future<void> init() async {
    var storage = new FlutterSecureStorage();
    String res = await storage.read(key: "saved_servers");

    if (res == null) {
      _entries = <Server>[];
      return;
    }

    List<dynamic> decoded = jsonDecode(res);
    _entries = decoded.map((e) => Server.fromJson(e)).toList();
  }

  Future<void> save() async {
    var storage = new FlutterSecureStorage();
    String str = jsonEncode(_entries);
    await storage.write(key: "saved_servers", value: str);
  }
}
