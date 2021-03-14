import 'package:flutter/material.dart';
import 'package:fludip/pages/login.dart';
import 'package:provider/provider.dart';

import 'provider/user.dart';

void main() => runApp(App());

//TODO localisation

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider.value(value: User()),
    ],
    child: MaterialApp(
      title: "Fludip",
      home: LoginPage(),
    ));
  }
}