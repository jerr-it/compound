import 'package:flutter/material.dart';

const String REST_API_URL = "/api.php";
const String JSON_API_URL = "/jsonapi.php/v1";

/// Server bundles information related to authentication and content pulling
class Server {
  String _name;
  String _logoURL;

  String _webAddress;

  Server({
    @required name,
    @required logoURL,
    @required webAddress,
  })  : _name = name,
        _logoURL = logoURL,
        _webAddress = webAddress;

  String get name => this._name;
  String get logoURL => this._logoURL;
  String get webAddress => this._webAddress;

  static String userID;
  //Prepared list of instances
  static List<Server> instances = [
    Server(
      name: "localhost",
      logoURL: "https://cdn.pixabay.com/photo/2017/05/12/15/16/hexagon-2307348_960_720.png",
      webAddress: "http://192.168.122.235/studip",
    ),
    Server(
      name: "Universität ABC",
      logoURL: "https://cdn.pixabay.com/photo/2016/07/28/11/06/university-1547551_960_720.png",
      webAddress: "",
    ),
    Server(
      name: "University of Example",
      logoURL: "https://cdn.pixabay.com/photo/2017/02/01/09/55/arrow-2029273_960_720.png",
      webAddress: "",
    ),
  ];
}
