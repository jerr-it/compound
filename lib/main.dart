import 'package:flutter/material.dart';
import 'package:fludip/pages/login.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Fludip",
      home: LoginPage(),
    );
  }
}