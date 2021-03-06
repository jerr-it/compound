import 'package:flutter/material.dart';

import 'package:fludip/navdrawer/navdrawerheader.dart';

import 'package:fludip/pages/community.dart';
import 'package:fludip/pages/files.dart';
import 'package:fludip/pages/messages.dart';
import 'package:fludip/pages/planner.dart';
import 'package:fludip/pages/profile.dart';
import 'package:fludip/pages/blackboard.dart';
import 'package:fludip/pages/start.dart';
import 'package:fludip/pages/search.dart';
import 'package:fludip/pages/tools.dart';
import 'package:fludip/pages/events.dart';

//TODO maybe open profile via drawer header?

//Animation between pages
Route navRoute(Widget page){
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
              color:Colors.blue,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Start"),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(navRoute(StartPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.book_rounded),
            title: Text("Veranstaltungen"),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(navRoute(EventsPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.mail),
            title: Text("Nachrichten"),
            onTap: () {
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
          )
        ],
      )
    );
  }
}
