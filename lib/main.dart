import 'package:fludip/provider/blubberProvider.dart';
import 'package:fludip/provider/course/forumProvider.dart';
import 'package:fludip/provider/course/membersProvider.dart';
import 'package:fludip/provider/coursesProvider.dart';
import 'package:fludip/provider/globalNewsProvider.dart';
import 'package:fludip/provider/course/fileProvider.dart';
import 'package:fludip/provider/messageProvider.dart';
import 'package:flutter/material.dart';
import 'package:fludip/pages/loginPage.dart';
import 'package:provider/provider.dart';

import 'provider/userProvider.dart';

void main() => runApp(App());

//TODO localisation
//TODO user settings:
// 1. custom colors for courses
// 2. (fingerprint?) unlock

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => GlobalNewsProvider()),
        ChangeNotifierProvider(create: (_) => CoursesProvider()),
        ChangeNotifierProvider(create: (_) => ForumProvider()),
        ChangeNotifierProvider(create: (_) => MembersProvider()),
        ChangeNotifierProvider(create: (_) => FileProvider()),
        ChangeNotifierProvider(create: (_) => MessageProvider()),
        ChangeNotifierProvider(create: (_) => BlubberProvider()),
      ],
      child: MaterialApp(
        title: "Fludip",
        home: LoginPage(),
      ),
    );
  }
}
