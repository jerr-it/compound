import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:oauth1/oauth1.dart' as oauth1;
import 'package:url_launcher/url_launcher.dart';
import 'server.dart';

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

enum APIType { REST, JSON }

///WebClient is the interface to the server
///Written as a singleton, there's always only going to be one of these
///Uses StudIP-Session-Cookies to authenticate with the server
class WebClient {
  static final WebClient _client = WebClient._internal();
  WebClient._internal();

  factory WebClient() {
    return _client;
  }

  Server _server;
  oauth1.Client _oauthClient;
  String _sessionCookie;

  Server get server => this._server;
  oauth1.Client get internal => this._oauthClient;
  String get sessionCookie => this._sessionCookie;

  set server(Server server) => this._server = server;

  ///Returns true if authentication is completed
  bool isAuthenticated() {
    return _oauthClient != null;
  }

  ///Deletes credentials from storage and reroutes to the login page
  void logout() async {
    var storage = new FlutterSecureStorage();
    await storage.delete(key: "oauth_credentials");

    _oauthClient.close();
  }

  ///Performs first time authentication with the server
  ///Return value is a HTTP status code
  Future<int> authenticate() async {
    var platform = new oauth1.Platform(
        _server.requestTokenUrl, _server.authorizeUrl, _server.accessTokenUrl, oauth1.SignatureMethods.hmacSha1);
    var clientCredentials = new oauth1.ClientCredentials(_server.consumerKey, _server.consumerSecret);

    var storage = new FlutterSecureStorage();
    var jsonCredentialStr = await storage.read(key: "oauth_credentials");

    //Test if the loaded credentials are actually valid
    if (jsonCredentialStr != null) {
      var decoded = jsonDecode(jsonCredentialStr);
      var credentials = oauth1.Credentials.fromMap(<String, String>{
        "oauth_token": decoded["oauth_token"],
        "oauth_token_secret": decoded["oauth_token_secret"],
      });

      _oauthClient = new oauth1.Client(platform.signatureMethod, clientCredentials, credentials);

      http.Response probe = await httpGet("/discovery", APIType.REST);
      if (probe.statusCode == 200) {
        _sessionCookie = probe.headers["set-cookie"];
        return Future<int>.value(probe.statusCode);
      }
    }

    //Loaded credentials aren't valid, get new ones

    var auth = new oauth1.Authorization(clientCredentials, platform);

    oauth1.AuthorizationResponse res = await auth.requestTemporaryCredentials("http://localhost:8080/").then((res) async {
      Stream<String> onCode = await _localCallbackServer();

      launch(auth.getResourceOwnerAuthorizationURI(res.credentials.token));

      String verifier = await onCode.first;
      return auth.requestTokenCredentials(res.credentials, verifier);
    });

    await storage.write(key: "oauth_credentials", value: jsonEncode(res.credentials.toJSON()));
    _oauthClient = new oauth1.Client(platform.signatureMethod, clientCredentials, res.credentials);

    http.Response probe = await httpGet("/discovery", APIType.REST);
    _sessionCookie = probe.request.headers["Cookie"];

    return Future<int>.value(200);
  }

  Future<Stream<String>> _localCallbackServer() async {
    final StreamController<String> onCode = new StreamController();
    String callbackPage = await rootBundle.loadString("assets/callbackPage.html");

    HttpServer server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);

    server.listen((HttpRequest request) async {
      final String code = request.uri.queryParameters["oauth_verifier"];

      request.response
        ..statusCode = 200
        ..headers.set("Content-Type", ContentType.html.mimeType)
        ..write(callbackPage);

      await request.response.close();
      await server.close(force: true);
      onCode.add(code);
      await onCode.close();
    });

    return onCode.stream;
  }

  ///Constructs the base url for requests depending on what type of API we're using (JSON/REST)
  String _constructBaseURL(APIType type) {
    return _server.webAddress + (type == APIType.REST ? REST_API_URL : JSON_API_URL);
  }

  //JSON api requires an additional header field
  Map<String, String> _adjustHeader(APIType type, Map<String, String> headers) {
    //Apply authentication to header
    var newHeader = Map.of(headers);

    newHeader["Cookie"] = _sessionCookie;

    //Apply correct content type in case of JSON api
    if (type == APIType.JSON) {
      newHeader["Content-Type"] = "application/vnd.api+json";
    }

    return newHeader;
  }

  ///Wraps http get requests so that authentication is added
  Future<http.Response> httpGet(
    String route,
    APIType type, {
    Map<String, String> headers = const <String, String>{},
    Map<String, dynamic> urlParams = const <String, String>{},
  }) {
    return _oauthClient.get(
      Uri.parse(_constructBaseURL(type) + route).replace(queryParameters: urlParams),
      headers: _adjustHeader(type, headers),
    );
  }

  ///Wraps http post requests so that authentication is added
  Future<http.Response> httpPost(
    String route,
    APIType type, {
    Map<String, String> headers = const <String, String>{},
    dynamic body = "",
  }) {
    return _oauthClient.post(
      Uri.parse(_constructBaseURL(type) + route),
      headers: _adjustHeader(type, headers),
      body: body,
    );
  }

  ///Wraps http put requests so that authentication is added
  Future<http.Response> httpPut(
    String route,
    APIType type, {
    Map<String, String> headers = const <String, String>{},
    dynamic body = "",
  }) {
    return _oauthClient.put(
      Uri.parse(_constructBaseURL(type) + route),
      headers: _adjustHeader(type, headers),
      body: body,
    );
  }

  ///Wraps http delete requests so that authentication is added
  Future<http.Response> httpDelete(
    String route,
    APIType type, {
    Map<String, String> headers = const <String, String>{},
  }) {
    return _oauthClient.delete(
      Uri.parse(_constructBaseURL(type) + route),
      headers: _adjustHeader(type, headers),
    );
  }
}
