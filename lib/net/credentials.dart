import 'dart:convert';

import 'package:flutter/material.dart';

class Credentials {
  String _username;
  String _password;

  String get username => this._username;
  String get password => this._password;

  Credentials(String username, String password)
      : _username = username,
        _password = password;

  String encodeB64() {
    return base64.encode(utf8.encode("$_username:$_password"));
  }
}
