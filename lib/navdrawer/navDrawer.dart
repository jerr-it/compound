import 'package:fludip/net/webClient.dart';
import 'package:fludip/pages/login/universitySelectPage.dart';
import 'package:fludip/pages/planner/scheduleView.dart';
import 'package:fludip/provider/user/userModel.dart';
import 'package:fludip/provider/user/userProvider.dart';
import 'package:flutter/material.dart';

import 'package:fludip/navdrawer/navDrawerHeader.dart';

import 'package:fludip/pages/community/communityPage.dart';
import 'package:fludip/pages/filesPage.dart';
import 'package:fludip/pages/messages/messagesPage.dart';
import 'package:fludip/pages/profilePage.dart';
import 'package:fludip/pages/blackboardPage.dart';
import 'package:fludip/pages/startPage.dart';
import 'package:fludip/pages/searchPage.dart';
import 'package:fludip/pages/course/coursePage.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

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
            title: Text("start".tr()),
            onTap: () async {
              Navigator.pop(context);
              Navigator.of(context).push(navRoute(StartPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.book_rounded),
            title: Text("event".tr()),
            onTap: () async {
              User user = await Provider.of<UserProvider>(context, listen: false).get("self");

              Navigator.pop(context);
              Navigator.of(context).push(navRoute(CoursePage(user.userID)));
            },
          ),
          ListTile(
            leading: Icon(Icons.mail),
            title: Text("messages".tr()),
            onTap: () async {
              User user = await Provider.of<UserProvider>(context, listen: false).get("self");

              Navigator.pop(context);
              Navigator.of(context).push(navRoute(MessagesPage(user.userID)));
            },
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text("community".tr()),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(navRoute(CommunityPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("profile".tr()),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(navRoute(ProfilePage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.event),
            title: Text("planner".tr()),
            onTap: () async {
              User user = await Provider.of<UserProvider>(context, listen: false).get("self");

              Navigator.pop(context);
              Navigator.of(context).push(navRoute(ScheduleViewer(user.userID)));
            },
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text("search".tr()),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(navRoute(SearchPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.file_copy),
            title: Text("files".tr()),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(navRoute(FilePage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.announcement_outlined),
            title: Text("noticeBoard".tr()),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(navRoute(BlackboardPage()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("settings".tr()),
            onTap: () {
              //Reroute to settings page
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("logout".tr()),
            onTap: () {
              var client = WebClient();
              client.logout();

              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushReplacement(context, navRoute(UniversitySelectPage()));
            },
          ),
        ],
      ),
    );
  }
}
