import 'package:flutter/material.dart';

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

const String REST_API_URL = "/api.php";
const String JSON_API_URL = "/jsonapi.php/v1";
const String REQUEST_TOKEN_URL = "/dispatch.php/api/oauth/request_token";
const String ACCESS_TOKEN_URL = "/dispatch.php/api/oauth/access_token";
const String AUTHORIZE_URL = "/dispatch.php/api/oauth/authorize";

/// Server bundles information related to authentication and content retrieval
class Server {
  String _name;
  String _webAddress;
  String _consumerKey;
  String _consumerSecret;

  Server({
    @required name,
    @required webAddress,
    @required consumerKey,
    @required consumerSecret,
  }) {
    _name = name;
    _webAddress = webAddress;
    _consumerKey = consumerKey;
    _consumerSecret = consumerSecret;
  }

  String get name => this._name;
  String get webAddress => this._webAddress;

  String get consumerKey => this._consumerKey;
  String get consumerSecret => this._consumerSecret;

  String get requestTokenUrl => this.webAddress + REQUEST_TOKEN_URL;
  String get accessTokenUrl => this.webAddress + ACCESS_TOKEN_URL;
  String get authorizeUrl => this.webAddress + AUTHORIZE_URL;

  static List<Server> instances = [
    Server(
      name: "localhost",
      webAddress: "http://192.168.122.235/studip",
      consumerKey: "bf0922a1dd225c66f4eaf2530e9982a9061698ac2",
      consumerSecret: "6f1b93176b783f82ddc3d465b8e1ea9c",
    )
  ];
}
