import 'package:compound/navdrawer/navDrawerHeader.dart';
import 'package:compound/net/webClient.dart';
import 'package:compound/pages/community/communityPage.dart';
import 'package:compound/pages/course/page/coursePage.dart';
import 'package:compound/pages/filesPage.dart';
import 'package:compound/pages/login/serverSelectPage.dart';
import 'package:compound/pages/messages/messagesPage.dart';
import 'package:compound/pages/planner/scheduleView.dart';
import 'package:compound/pages/profilePage.dart';
import 'package:compound/pages/search/searchPage.dart';
import 'package:compound/pages/settings.dart';
import 'package:compound/pages/startPage.dart';
import 'package:compound/provider/blubber/blubberProvider.dart';
import 'package:compound/provider/calendar/calendarProvider.dart';
import 'package:compound/provider/course/courseProvider.dart';
import 'package:compound/provider/course/files/fileProvider.dart';
import 'package:compound/provider/course/forum/forumProvider.dart';
import 'package:compound/provider/course/members/membersProvider.dart';
import 'package:compound/provider/messages/messageProvider.dart';
import 'package:compound/provider/news/newsProvider.dart';
import 'package:compound/provider/user/userModel.dart';
import 'package:compound/provider/user/userProvider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

//TODO maybe open profile via drawer header?

///Animation between pages
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

///Resets all providers
void _resetProviderCache(BuildContext context) {
  Provider.of<BlubberProvider>(context, listen: false).resetCache();
  Provider.of<CalendarProvider>(context, listen: false).resetCache();
  Provider.of<FileProvider>(context, listen: false).resetCache();
  Provider.of<ForumProvider>(context, listen: false).resetCache();

  Provider.of<MembersProvider>(context, listen: false).resetCache();
  Provider.of<CourseProvider>(context, listen: false).resetCache();
  Provider.of<MessageProvider>(context, listen: false).resetCache();
  Provider.of<NewsProvider>(context, listen: false).resetCache();

  Provider.of<UserProvider>(context, listen: false).resetCache();
}

///Main drawer widget
///Should be the default
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
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Theme.of(context).hintColor),
            title: Text("start".tr()),
            onTap: () async {
              Navigator.pop(context);
              Navigator.of(context).push(navRoute(StartPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.book_rounded, color: Theme.of(context).hintColor),
            title: Text("event".tr()),
            onTap: () async {
              User user = await Provider.of<UserProvider>(context, listen: false).get("self");

              Navigator.pop(context);
              Navigator.of(context).push(navRoute(CoursePage(context, user.userID)));
            },
          ),
          ListTile(
            leading: Icon(Icons.mail, color: Theme.of(context).hintColor),
            title: Text("messages".tr()),
            onTap: () async {
              User user = await Provider.of<UserProvider>(context, listen: false).get("self");

              Navigator.pop(context);
              Navigator.of(context).push(navRoute(MessagesPage(user.userID)));
            },
          ),
          ListTile(
            leading: Icon(Icons.people, color: Theme.of(context).hintColor),
            title: Text("community".tr()),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(navRoute(CommunityPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: Theme.of(context).hintColor),
            title: Text("profile".tr()),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(navRoute(ProfilePage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.event, color: Theme.of(context).hintColor),
            title: Text("planner".tr()),
            onTap: () async {
              User user = await Provider.of<UserProvider>(context, listen: false).get("self");

              Navigator.pop(context);
              Navigator.of(context).push(navRoute(ScheduleViewer(user.userID)));
            },
          ),
          ListTile(
            leading: Icon(Icons.search, color: Theme.of(context).hintColor),
            title: Text("search".tr()),
            onTap: () async {
              User user = await Provider.of<UserProvider>(context, listen: false).get("self");

              Navigator.pop(context);
              Navigator.of(context).push(navRoute(SearchPage(user.userID)));
            },
          ),
          ListTile(
            leading: Icon(Icons.file_copy, color: Theme.of(context).hintColor),
            title: Text("files".tr()),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(navRoute(FilePage()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings, color: Theme.of(context).hintColor),
            title: Text("settings".tr()),
            onTap: () {
              //Reroute to settings page
              Navigator.pop(context);
              Navigator.of(context).push(navRoute(SettingsPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Theme.of(context).hintColor),
            title: Text("logout".tr()),
            onTap: () {
              var client = WebClient();
              client.logout();

              _resetProviderCache(context);

              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushReplacement(context, navRoute(ServerSelectPage()));
            },
          ),
          Divider(),
          AboutListTile(
            child: Text("about".tr()),
            icon: Icon(Icons.text_fields, color: Theme.of(context).hintColor),
            applicationVersion: "1.0.0",
            applicationLegalese: "Released under the GNU General Public License version 3",
          ),
        ],
      ),
    );
  }
}
