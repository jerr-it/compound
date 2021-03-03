//Singleton
import 'dart:convert';
import 'package:http/http.dart' as http;

//HTTP Basic authentication
//TODO: maybe session/oauth?
class WebClient {
  static final WebClient _client = WebClient._internal();
  static String _b64credentials;
  static String _baseUrl;

  factory WebClient(){
    return _client;
  }

  void setServer(String bUrl){
    _baseUrl = bUrl;
  }

  void setCredentials(String usr, String pwd){
    var bytes = utf8.encode(usr + ":" + pwd);
    _b64credentials = base64.encode(bytes);
  }

  WebClient._internal();

  Future<String> get(String route) async {
    String url = _baseUrl + route;
    print(url);
    var response = await http.get(
      url,
      headers: <String,String>{
        "Authorization" : "Basic " + _b64credentials,
      }
    );

    return response.body;
  }
}