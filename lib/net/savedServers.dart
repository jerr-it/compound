import 'dart:convert';

import 'package:compound/net/server.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

///Stores the StudIP instances the user enters on the first page
class SavedServers {
  static final SavedServers _savedServers = SavedServers._internal();
  SavedServers._internal();

  factory SavedServers() {
    return _savedServers;
  }

  List<Server> _entries;
  List<Server> get entries => this._entries;

  ///Initialise the list.
  ///Async because it needs to retrieve already entered servers from the device storage.
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

  ///Saves all entered StudIP instances securely
  Future<void> save() async {
    var storage = new FlutterSecureStorage();
    String str = jsonEncode(_entries);
    await storage.write(key: "saved_servers", value: str);
  }
}
