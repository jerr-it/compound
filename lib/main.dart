import 'package:fludip/provider/course/forumProvider.dart';
import 'package:fludip/provider/course/membersProvider.dart';
import 'package:fludip/provider/coursesProvider.dart';
import 'package:fludip/provider/globalNewsProvider.dart';
import 'package:flutter/material.dart';
import 'package:fludip/pages/loginPage.dart';
import 'package:provider/provider.dart';

import 'provider/userProvider.dart';

void main() => runApp(App());

//TODO localisation

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => GlobalNewsProvider()),
          ChangeNotifierProvider(create: (_) => CoursesProvider()),
          ChangeNotifierProvider(create: (_) => ForumProvider()),
          ChangeNotifierProvider(create: (_) => MembersProvider())
        ],
        child: MaterialApp(
          title: "Fludip",
          home: LoginPage(),
        ));
  }
}
