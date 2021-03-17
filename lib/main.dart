import 'package:fludip/provider/course/forum.dart';
import 'package:fludip/provider/courses.dart';
import 'package:fludip/provider/globalnews.dart';
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
      ChangeNotifierProvider(create: (_) => GlobalNewsProvider()),
      ChangeNotifierProvider(create: (_) => CoursesProvider()),
      ChangeNotifierProvider(create: (_) => ForumProvider()),
    ],
    child: MaterialApp(
      title: "Fludip",
      home: LoginPage(),
    ));
  }
}