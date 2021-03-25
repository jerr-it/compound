import 'package:fludip/net/webClient.dart';
import 'package:fludip/pages/loginPage.dart';
import 'package:fludip/provider/coursesProvider.dart';
import 'package:fludip/provider/globalNewsProvider.dart';
import 'package:fludip/provider/messageProvider.dart';
import 'package:fludip/provider/userProvider.dart';
import 'package:flutter/material.dart';

import 'package:fludip/navdrawer/navDrawerHeader.dart';

import 'package:fludip/pages/communityPage.dart';
import 'package:fludip/pages/filesPage.dart';
import 'package:fludip/pages/messages/messagesPage.dart';
import 'package:fludip/pages/plannerPage.dart';
import 'package:fludip/pages/profilePage.dart';
import 'package:fludip/pages/blackboardPage.dart';
import 'package:fludip/pages/startPage.dart';
import 'package:fludip/pages/searchPage.dart';
import 'package:fludip/pages/toolsPage.dart';
import 'package:fludip/pages/course/coursePage.dart';
import 'package:provider/provider.dart';

//TODO maybe open profile via drawer header?

//Animation between pages
Route navRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(
        begin: begin,
        end: end,
      ).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: NavDrawerHeader(),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Start"),
            onTap: () async {
              //Only do it once at the start to improve nav drawer performance
              if (!Provider.of<GlobalNewsProvider>(context, listen: false).initialized()) {
                Provider.of<GlobalNewsProvider>(context, listen: false).update();
              }

              Navigator.pop(context);
              Navigator.of(context).push(navRoute(StartPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.book_rounded),
            title: Text("Veranstaltungen"),
            onTap: () async {
              if (!Provider.of<CoursesProvider>(context, listen: false).initialized()) {
                String userID = Provider.of<UserProvider>(context, listen: false).getData()["user_id"];
                Provider.of<CoursesProvider>(context, listen: false).setUserID(userID);
                Provider.of<CoursesProvider>(context, listen: false).update();
              }

              Navigator.pop(context);
              Navigator.of(context).push(navRoute(CoursePage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.mail),
            title: Text("Nachrichten"),
            onTap: () {
              if (!Provider.of<MessageProvider>(context, listen: false).initialized()) {
                String userID = Provider.of<UserProvider>(context, listen: false).getData()["user_id"];
                Provider.of<MessageProvider>(context, listen: false).setUserID(userID);
                Provider.of<MessageProvider>(context, listen: false).update();
              }

              Navigator.pop(context);
              Navigator.of(context).push(navRoute(MessagesPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text("Community"),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(navRoute(CommunityPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Profil"),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(navRoute(ProfilePage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.event),
            title: Text("Planer"),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(navRoute(PlannerPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text("Suche"),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(navRoute(SearchPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.api),
            title: Text("Tools"),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(navRoute(ToolsPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.file_copy),
            title: Text("Dateien"),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(navRoute(FilePage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.announcement_outlined),
            title: Text("Schwarzes Brett"),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(navRoute(BlackboardPage()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            onTap: () {
              //Reroute to settings page
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () {
              var client = WebClient();
              client.logout();

              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushReplacement(context, navRoute(LoginPage()));
            },
          ),
        ],
      ),
    );
  }
}
