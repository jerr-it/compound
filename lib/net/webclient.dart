import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

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

  //Pre-prepared list of instances
  static List<Server> instances = [
    Server(
      name: "Example University",
      consumerKey: "CONSUMER_KEY",
      consumerSecret: "CONSUMER_SECRET",
      requestTokenUrl: "http://studip.example.org/dispatch.php/api/oauth/request_token",
      accessTokenUrl: "http://studip.example.org/dispatch.php/api/oauth/access_token",
      authorizeUrl: "http://studip.example.org/dispatch.php/api/oauth/authorize",
      baseUrl: "http://studip.example.org/api.php/",
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
  void setServer(Server server){
    this._server = server;
  }

  //TODO implement Oauth process
  //TODO implement routes
  //For now use fake provider
}