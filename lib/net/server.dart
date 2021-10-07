import 'package:flutter/material.dart';

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
