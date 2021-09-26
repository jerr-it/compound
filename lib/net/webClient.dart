import 'dart:async';

import 'dart:io';

import 'package:fludip/net/credentials.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'server.dart';

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
  Credentials _credentials;

  set server(Server server) => this._server = server;

  ///Returns true if authentication is completed
  bool isAuthenticated() {
    return _credentials != null;
  }

  ///Deletes credentials from storage and reroutes to the login page
  void logout() async {
    var storage = new FlutterSecureStorage();
    await storage.delete(key: "username");
    await storage.delete(key: "password");
  }

  ///Performs OAuth1 authentication with the set server
  Future<int> authenticate(String username, String password) async {
    _credentials = new Credentials(username, password);

    //Probe both REST and JSON api

    var restResponse = await httpGet("/discovery", APIType.REST);
    if (restResponse.statusCode != 200) {
      return restResponse.statusCode;
    }

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
    newHeader["Authorization"] = "Basic " + _credentials.encodeB64();

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
  }) {
    return http.get(
      Uri.parse(_constructBaseURL(type) + route),
      headers: _adjustHeader(type, headers),
    );
  }

  Future<http.Response> httpPost(
    String route,
    APIType type, {
    Map<String, String> headers = const <String, String>{},
    dynamic body = "",
  }) {
    return http.post(
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
    return http.put(
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
    return http.delete(
      Uri.parse(_constructBaseURL(type) + route),
      headers: _adjustHeader(type, headers),
    );
  }
}
