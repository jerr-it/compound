import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:oauth1/oauth1.dart' as oauth1;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String REQUEST_TOKEN_URL = "/dispatch.php/api/oauth/request_token";
const String ACCESS_TOKEN_URL = "/dispatch.php/api/oauth/access_token";
const String AUTHORIZE_URL = "/dispatch.php/api/oauth/authorize";
const String REST_API_URL = "/api.php";
const String JSON_API_URL = "/jsonapi.php/v1";

/// Server bundles information related to authentication and content pulling
class Server {
  String _name;
  String _logoURL;
  Color _color;

  String _consumerKey;
  String _consumerSecret;

  String _webAddress;

  Server({
    @required name,
    @required logoURL,
    @required color,
    @required consumerKey,
    @required consumerSecret,
    @required webAddress,
  })  : _name = name,
        _logoURL = logoURL,
        _color = color,
        _consumerKey = consumerKey,
        _consumerSecret = consumerSecret,
        _webAddress = webAddress;

  String name() {
    return _name;
  }

  String logoURL() {
    return _logoURL;
  }

  Color color() {
    return _color;
  }

  static String userID;
  //Pre-prepared list of instances
  //TODO move this to a secured space, ok for now since the given server is a local
  static List<Server> instances = [
    Server(
      name: "localhost",
      logoURL: "https://cdn.pixabay.com/photo/2017/05/12/15/16/hexagon-2307348_960_720.png",
      color: Colors.red,
      consumerKey: "f25655936896bdfa73c15d6b6cf50e670604a8832",
      consumerSecret: "650da6e031cae19289ff23f05f85fa80",
      webAddress: "http://192.168.122.235/studip",
    ),
    Server(
      name: "Universität ABC",
      logoURL: "https://cdn.pixabay.com/photo/2016/07/28/11/06/university-1547551_960_720.png",
      color: Colors.lightBlue,
      consumerKey: "",
      consumerSecret: "",
      webAddress: "",
    ),
    Server(
      name: "University of Example",
      logoURL: "https://cdn.pixabay.com/photo/2017/02/01/09/55/arrow-2029273_960_720.png",
      color: Colors.purple,
      consumerKey: "",
      consumerSecret: "",
      webAddress: "",
    ),
  ];
}

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
  oauth1.Client _oauthClient;

  void setServer(Server server) {
    this._server = server;
  }

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

  ///Acts as a callback target for oauth
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

  ///Performs OAuth1 authentication with the set server
  Future<int> authenticate() async {
    var platform = new oauth1.Platform(_server._webAddress + REQUEST_TOKEN_URL, _server._webAddress + AUTHORIZE_URL,
        _server._webAddress + ACCESS_TOKEN_URL, oauth1.SignatureMethods.hmacSha1);

    var clientCredentials = new oauth1.ClientCredentials(this._server._consumerKey, this._server._consumerSecret);

    var storage = new FlutterSecureStorage();
    var jsonCredentialStr = await storage.read(key: "oauth_credentials");

    if (jsonCredentialStr != null) {
      var jsonCredentials = jsonDecode(jsonCredentialStr);

      var credentials = oauth1.Credentials.fromMap(<String, String>{
        "oauth_token": jsonCredentials["oauth_token"],
        "oauth_token_secret": jsonCredentials["oauth_token_secret"],
      });

      _oauthClient = new oauth1.Client(platform.signatureMethod, clientCredentials, credentials);

      //Test if the loaded token actually works
      Response restProbe = await httpGet("/discovery", APIType.REST).timeout(Duration(seconds: 5), onTimeout: () async {
        return Response("{}", 900);
      });

      Response jsonProbe = await httpGet("/discovery", APIType.JSON).timeout(Duration(seconds: 5), onTimeout: () async {
        return Response("{}", 900);
      });

      //Return if the connection was successfully tested, or a timeout occurred
      //In both cases we dont want to do a new oauth setup
      if (restProbe.statusCode == 200 || restProbe.statusCode == 900) {
        return Future<int>.value(restProbe.statusCode);
      }
    }

    var auth = new oauth1.Authorization(clientCredentials, platform);

    var res = await auth.requestTemporaryCredentials("http://localhost:8080/").then((res) async {
      Stream<String> onCode = await _localCallbackServer();

      launch(auth.getResourceOwnerAuthorizationURI(res.credentials.token));

      String verifier = await onCode.first;
      return auth.requestTokenCredentials(res.credentials, verifier);
    });

    await storage.write(key: "oauth_credentials", value: jsonEncode(res.credentials.toJSON()));
    _oauthClient = new oauth1.Client(platform.signatureMethod, clientCredentials, res.credentials);

    return Future<int>.value(200);
  }

  String _constructBaseURL(APIType type) {
    return _server._webAddress + (type == APIType.REST ? REST_API_URL : JSON_API_URL);
  }

  Future<Response> httpGet(
    String route,
    APIType type, {
    Map<String, String> headers = const <String, String>{},
  }) {
    return _oauthClient.get(_constructBaseURL(type) + route, headers: headers);
  }

  Future<Response> httpPost(
    String route,
    APIType type, {
    Map<String, String> headers = const <String, String>{},
    dynamic body = "",
  }) {
    return _oauthClient.post(
      _constructBaseURL(type) + route,
      headers: headers,
      body: body,
    );
  }

  Future<Response> httpPut(
    String route,
    APIType type, {
    Map<String, String> headers = const <String, String>{},
    dynamic body = "",
  }) {
    return _oauthClient.put(
      _constructBaseURL(type) + route,
      headers: headers,
      body: body,
    );
  }

  Future<Response> httpDelete(
    String route,
    APIType type, {
    Map<String, String> headers = const <String, String>{},
  }) {
    return _oauthClient.delete(
      _constructBaseURL(type) + route,
      headers: headers,
    );
  }
}
