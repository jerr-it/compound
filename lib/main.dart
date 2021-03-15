import 'package:fludip/provider/events.dart';
import 'package:fludip/provider/news.dart';
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
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => NewsProvider()),
      ChangeNotifierProvider(create: (_) => EventProvider()),
    ],
    child: MaterialApp(
      title: "Fludip",
      home: LoginPage(),
    ));
  }
}