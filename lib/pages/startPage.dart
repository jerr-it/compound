import 'package:compound/navdrawer/navDrawer.dart';
import 'package:compound/provider/course/semester/semesterProvider.dart';
import 'package:compound/provider/news/newsModel.dart';
import 'package:compound/provider/news/newsProvider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:compound/util/widgets/Announcement.dart';
import 'package:compound/util/widgets/Nothing.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

///Page you reach once you log in.
///Displays global StudIP news
class StartPage extends StatelessWidget {
  ///Convert data to widgets
  List<Widget> _buildListEntries(List<News> announcements) {
    List<Widget> widgets = <Widget>[];
    if (announcements == null) {
      return widgets;
    }

    if (announcements.isEmpty) {
      widgets.add(Nothing());
    }

    announcements.forEach((news) {
      Widget html = Html(data: news.body.toString());

      widgets.add(Announcement(title: news.topic, time: news.chdate, body: html));
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    Future<List<News>> news = Provider.of<NewsProvider>(context).get("global");
    Provider.of<SemesterProvider>(context, listen: false).init();

    return Scaffold(
      appBar: AppBar(
        title: Text("start".tr(), style: GoogleFonts.montserrat()),
      ),
      body: FutureBuilder(
        future: news,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              child: ListView(
                children: _buildListEntries(snapshot.data),
              ),
              onRefresh: () {
                return Provider.of<NewsProvider>(context, listen: false).forceUpdate("global");
              },
            );
          }
          if (snapshot.hasError) {
            return RefreshIndicator(
              child: ErrorWidget(snapshot.error.toString()),
              onRefresh: () {
                return Provider.of<NewsProvider>(context, listen: false).forceUpdate("global");
              },
            );
          }
          return Container(
            child: LinearProgressIndicator(),
          );
        },
      ),
      drawer: NavDrawer(),
    );
  }
}
