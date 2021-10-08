import 'package:flutter/material.dart';

// Fludip - Mobile StudIP client
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

const String REST_API_URL = "/api.php";
const String JSON_API_URL = "/jsonapi.php/v1";

/// Server bundles information related to authentication and content pulling
class Server {
  String _name;
  String _webAddress;

  Server({
    @required name,
    @required webAddress,
  })  : _name = name,
        _webAddress = webAddress;

  String get name => this._name;
  String get webAddress => this._webAddress;

  Map<String, dynamic> toJson() {
    return {
      "name": _name,
      "webAdress": _webAddress,
    };
  }

  Server.fromJson(Map<String, dynamic> data) {
    _name = data["name"];
    _webAddress = data["webAdress"];
  }
}
