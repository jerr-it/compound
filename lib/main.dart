import 'package:compound/pages/login/serverSelectPage.dart';
import 'package:compound/provider/blubber/blubberProvider.dart';
import 'package:compound/provider/calendar/calendarProvider.dart';
import 'package:compound/provider/course/courseProvider.dart';
import 'package:compound/provider/course/files/fileProvider.dart';
import 'package:compound/provider/course/forum/forumProvider.dart';
import 'package:compound/provider/course/members/membersProvider.dart';
import 'package:compound/provider/course/semester/semesterProvider.dart';
import 'package:compound/provider/course/wiki/wikiProvider.dart';
import 'package:compound/provider/messages/messageProvider.dart';
import 'package:compound/provider/news/newsProvider.dart';
import 'package:compound/provider/themes/themeProvider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'provider/user/userProvider.dart';

// Compound - Mobile StudIP client
// Copyright (C) 2021 Jerrit Gläsker

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(EasyLocalization(
    supportedLocales: [Locale("en", "GB"), Locale("de", "DE")],
    path: "assets/translations",
    fallbackLocale: Locale("en", "GB"),
    child: App(),
  ));
}

//TODO user settings:
// 1. custom colors for courses
// 2. (fingerprint?) unlock

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeController(),
      child: Consumer(
        builder: (BuildContext context, ThemeController themeController, Widget child) {
          themeController.init();
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => UserProvider()),
              ChangeNotifierProvider(create: (_) => SemesterProvider()),
              ChangeNotifierProvider(create: (_) => NewsProvider()),
              ChangeNotifierProvider(create: (_) => CourseProvider()),
              ChangeNotifierProvider(create: (_) => ForumProvider()),
              ChangeNotifierProvider(create: (_) => MembersProvider()),
              ChangeNotifierProvider(create: (_) => FileProvider()),
              ChangeNotifierProvider(create: (_) => MessageProvider()),
              ChangeNotifierProvider(create: (_) => BlubberProvider()),
              ChangeNotifierProvider(create: (_) => CalendarProvider()),
              ChangeNotifierProvider(create: (_) => WikiProvider()),
            ],
            child: MaterialApp(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.deviceLocale,
              theme: themeController.theme,
              title: "Compound",
              home: ServerSelectPage(),
            ),
          );
        },
      ),
    );
  }
}
