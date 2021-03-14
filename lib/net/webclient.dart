import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:oauth1/oauth1.dart' as oauth1;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


/// Server bundles information related to authentication and content pulling
class Server {
  String _name;

  String _consumerKey;
  String _consumerSecret;

  String _requestTokenUrl;
  String _accessTokenUrl;
  String _authorizeUrl;
  String _baseUrl;

  Server({
    @required name,
    @required consumerKey,
    @required consumerSecret,
    @required requestTokenUrl,
    @required accessTokenUrl,
    @required authorizeUrl,
    @required baseUrl,
  }) :
        assert(name != null), _name = name,
        assert(consumerKey != null), _consumerKey = consumerKey,
        assert(consumerSecret != null), _consumerSecret = consumerSecret,
        assert(requestTokenUrl != null), _requestTokenUrl = requestTokenUrl,
        assert(accessTokenUrl != null), _accessTokenUrl = accessTokenUrl,
        assert(authorizeUrl != null), _authorizeUrl = authorizeUrl,
        assert(baseUrl != null), _baseUrl = baseUrl;

  String name(){
    return _name;
  }

  static String userID;
  //Pre-prepared list of instances
  //TODO move this to a secured space, ok for now since the given server is a local
  static List<Server> instances = [
    Server(
      name: "Local",
      consumerKey: "f25655936896bdfa73c15d6b6cf50e670604a8832",
      consumerSecret: "650da6e031cae19289ff23f05f85fa80",
      requestTokenUrl: "http://192.168.122.235/studip/dispatch.php/api/oauth/request_token",
      accessTokenUrl: "http://192.168.122.235/studip/dispatch.php/api/oauth/access_token",
      authorizeUrl: "http://192.168.122.235/studip/dispatch.php/api/oauth/authorize",
      baseUrl: "http://192.168.122.235/studip/api.php",
    ),
  ];
}

///WebClient is the interface to the server
///Written as a singleton, there's always only going to be one of these
class WebClient {
  static final WebClient _client = WebClient._internal();
  WebClient._internal();

  factory WebClient(){
    return _client;
  }

  Server _server;
  oauth1.Client _oauthClient;

  void setServer(Server server){
    this._server = server;
  }

  ///Returns true if authentication is completed
  bool isAuthenticated(){
    return _oauthClient != null;
  }

  ///Acts as a callback target for oauth
  Future<Stream<String>> _localCallbackServer() async {
    final StreamController<String> onCode = new StreamController();
    
    HttpServer server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
    server.listen((HttpRequest request) async {
      final String code = request.uri.queryParameters["oauth_verifier"];

      request.response
        ..statusCode = 200
        ..headers.set("Content-Type", ContentType.html.mimeType)
        ..write("<html><h1>You can close this window now</h1></html>");

      await request.response.close();
      await server.close(force: true);
      onCode.add(code);
      await onCode.close();
    });

    return onCode.stream;
  }

  ///Performs OAuth1 authentication with the set server
  ///TODO account for someone de-authorizing the app, which renders the locally saved oauth credentials invalid
  void authenticate() async {
    var platform = new oauth1.Platform(
      this._server._requestTokenUrl,
      this._server._authorizeUrl,
      this._server._accessTokenUrl,
      oauth1.SignatureMethods.hmacSha1
    );
    
    var clientCredentials = new oauth1.ClientCredentials(
      this._server._consumerKey,
      this._server._consumerSecret
    );

    var storage = new FlutterSecureStorage();
    var jsonCredentialStr = await storage.read(key: "oauth_credentials");

    if(jsonCredentialStr != null){
      var jsonCredentials = jsonDecode(jsonCredentialStr);

      var credentials = oauth1.Credentials.fromMap(<String,String>{
        "oauth_token":jsonCredentials["oauth_token"],
        "oauth_token_secret":jsonCredentials["oauth_token_secret"],
      });

      _oauthClient = new oauth1.Client(platform.signatureMethod, clientCredentials, credentials);

      //Test if the loaded token actually works
      var probe = await _oauthClient.get(this._server._baseUrl + "/discovery");
      if(probe.statusCode == 200){
        return;
      }
    }
    
    var auth = new oauth1.Authorization(clientCredentials, platform);
    
    auth.requestTemporaryCredentials("http://localhost:8080/").then((res) async {
      Stream<String> onCode = await _localCallbackServer();

      launch(auth.getResourceOwnerAuthorizationURI(res.credentials.token));

      String verifier = await onCode.first;
      return auth.requestTokenCredentials(res.credentials, verifier);
    }).then((res) async {
      await storage.write(key: "oauth_credentials", value: jsonEncode(res.credentials.toJSON()));

      _oauthClient = new oauth1.Client(platform.signatureMethod, clientCredentials, res.credentials);
    });
  }

  ///Execute a GET route
  Future<Map<String, dynamic>> getRoute(String route) async {
    if(_oauthClient == null){
      return Future<Map<String,String>>.value(null);
    }

    Response res = await _oauthClient.get(this._server._baseUrl + route);
    return jsonDecode(res.body);
  }
}