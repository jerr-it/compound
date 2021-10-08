import 'dart:async';

import 'package:compound/net/credentials.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'server.dart';

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

enum APIType { REST, JSON }

///WebClient is the interface to the server
///Written as a singleton, there's always only going to be one of these
class WebClient {
  static final WebClient _client = WebClient._internal();
  WebClient._internal();

  factory WebClient() {
    return _client;
  }

  Server _server;
  http.Client _httpClient;
  String _sessionCookie;

  Server get server => this._server;
  String get sessionCookie => this._sessionCookie;

  set server(Server server) => this._server = server;

  ///Returns true if authentication is completed
  bool isAuthenticated() {
    return _sessionCookie != null;
  }

  ///Deletes credentials from storage and reroutes to the login page
  void logout() async {
    var storage = new FlutterSecureStorage();
    await storage.delete(key: "username");
    await storage.delete(key: "password");

    _sessionCookie = null;

    _httpClient.close();
  }

  ///Performs OAuth1 authentication with the set server
  Future<int> authenticate(String username, String password) async {
    Credentials credentials = new Credentials(username, password);
    _httpClient = new http.Client();

    //Probe both REST and JSON api

    var restResponse = await httpGet("/discovery", APIType.REST, headers: {"Authorization": "Basic " + credentials.encoded});
    if (restResponse.statusCode != 200) {
      return restResponse.statusCode;
    }

    _sessionCookie = restResponse.headers["set-cookie"];

    var jsonResponse = await httpGet("/discovery", APIType.JSON);
    return Future<int>.value(jsonResponse.statusCode);
  }

  String _constructBaseURL(APIType type) {
    return _server.webAddress + (type == APIType.REST ? REST_API_URL : JSON_API_URL);
  }

  //JSON api requires an additional header field
  Map<String, String> _adjustHeader(APIType type, Map<String, String> headers) {
    //Apply authentication to header
    var newHeader = Map.of(headers);

    if (_sessionCookie != null) {
      newHeader["Cookie"] = _sessionCookie;
    }

    //Apply correct content type in case of JSON api
    if (type == APIType.JSON) {
      newHeader["Content-Type"] = "application/vnd.api+json";
    }

    return newHeader;
  }

  Future<http.Response> httpGet(
    String route,
    APIType type, {
    Map<String, String> headers = const <String, String>{},
    Map<String, dynamic> urlParams = const <String, String>{},
  }) {
    return _httpClient.get(
      Uri.parse(_constructBaseURL(type) + route).replace(queryParameters: urlParams),
      headers: _adjustHeader(type, headers),
    );
  }

  Future<http.Response> httpPost(
    String route,
    APIType type, {
    Map<String, String> headers = const <String, String>{},
    dynamic body = "",
  }) {
    return _httpClient.post(
      Uri.parse(_constructBaseURL(type) + route),
      headers: _adjustHeader(type, headers),
      body: body,
    );
  }

  Future<http.Response> httpPut(
    String route,
    APIType type, {
    Map<String, String> headers = const <String, String>{},
    dynamic body = "",
  }) {
    return _httpClient.put(
      Uri.parse(_constructBaseURL(type) + route),
      headers: _adjustHeader(type, headers),
      body: body,
    );
  }

  Future<http.Response> httpDelete(
    String route,
    APIType type, {
    Map<String, String> headers = const <String, String>{},
  }) {
    return _httpClient.delete(
      Uri.parse(_constructBaseURL(type) + route),
      headers: _adjustHeader(type, headers),
    );
  }
}
