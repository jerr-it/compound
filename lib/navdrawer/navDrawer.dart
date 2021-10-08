import 'package:easy_localization/easy_localization.dart';
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
import 'package:compound/pages/startPage.dart';
import 'package:compound/provider/blubber/blubberProvider.dart';
import 'package:compound/provider/calendar/calendarProvider.dart';
import 'package:compound/provider/course/courseProvider.dart';
import 'package:compound/provider/course/files/fileProvider.dart';
import 'package:compound/provider/course/forum/forumProvider.dart';
import 'package:compound/provider/course/members/membersProvider.dart';
import 'package:compound/provider/messages/messageProvider.dart';
import 'package:compound/provider/news/globalNewsProvider.dart';
import 'package:compound/provider/user/userModel.dart';
import 'package:compound/provider/user/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// Fludip - Mobile StudIP client
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
            title: Text("start".tr(), style: GoogleFonts.montserrat()),
            onTap: () async {
              Navigator.pop(context);
              Navigator.of(context).push(navRoute(StartPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.book_rounded),
            title: Text("event".tr(), style: GoogleFonts.montserrat()),
            onTap: () async {
              User user = await Provider.of<UserProvider>(context, listen: false).get("self");

              Navigator.pop(context);
              Navigator.of(context).push(navRoute(CoursePage(context, user.userID)));
            },
          ),
          ListTile(
            leading: Icon(Icons.mail),
            title: Text("messages".tr(), style: GoogleFonts.montserrat()),
            onTap: () async {
              User user = await Provider.of<UserProvider>(context, listen: false).get("self");

              Navigator.pop(context);
              Navigator.of(context).push(navRoute(MessagesPage(user.userID)));
            },
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text("community".tr(), style: GoogleFonts.montserrat()),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(navRoute(CommunityPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("profile".tr(), style: GoogleFonts.montserrat()),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(navRoute(ProfilePage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.event),
            title: Text("planner".tr(), style: GoogleFonts.montserrat()),
            onTap: () async {
              User user = await Provider.of<UserProvider>(context, listen: false).get("self");

              Navigator.pop(context);
              Navigator.of(context).push(navRoute(ScheduleViewer(user.userID)));
            },
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text("search".tr(), style: GoogleFonts.montserrat()),
            onTap: () async {
              User user = await Provider.of<UserProvider>(context, listen: false).get("self");

              Navigator.pop(context);
              Navigator.of(context).push(navRoute(SearchPage(user.userID)));
            },
          ),
          ListTile(
            leading: Icon(Icons.file_copy),
            title: Text("files".tr(), style: GoogleFonts.montserrat()),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(navRoute(FilePage()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("settings".tr(), style: GoogleFonts.montserrat()),
            onTap: () {
              //Reroute to settings page
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("logout".tr(), style: GoogleFonts.montserrat()),
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
            child: Text(
              "about".tr(),
              style: GoogleFonts.montserrat(),
            ),
            icon: Icon(Icons.text_fields),
            applicationVersion: "1.0.0",
            applicationLegalese: "Released under the GNU General Public License version 3",
          ),
        ],
      ),
    );
  }
}
