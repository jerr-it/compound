import 'dart:convert';

class Credentials {
  String _encoded;

  String get encoded => _encoded;

  Credentials(String username, String password) {
    _encoded = base64.encode(utf8.encode("$username:$password"));
  }
}
