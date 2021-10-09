import 'package:compound/provider/course/courseModel.dart';
import 'package:compound/provider/news/globalNewsProvider.dart';
import 'package:compound/provider/news/newsModel.dart';
import 'package:compound/util/str.dart';
import 'package:compound/util/widgets/Announcement.dart';
import 'package:compound/util/widgets/Nothing.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

class InfoLineWidget extends StatelessWidget {
  InfoLineWidget(String key, String value)
      : _key = key,
        _value = value;

  final String _key;
  final String _value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              _key,
              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                _value ?? "nothing".tr(),
                style: GoogleFonts.montserrat(),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class InfoTab extends StatelessWidget {
  final Course course;

  InfoTab({@required course}) : course = course;

  List<Widget> _gatherInfo() {
    List<Widget> widgets = <Widget>[];

    widgets.add(InfoLineWidget("number".tr(), course.number));
    widgets.add(InfoLineWidget("subtitle".tr(), course.subtitle));
    widgets.add(InfoLineWidget("description".tr(), course.description));
    widgets.add(InfoLineWidget("location".tr(), course.location));
    widgets.add(InfoLineWidget("start".tr(), course.startSemester.title));
    widgets.add(InfoLineWidget("end".tr(), course.endSemester.title));
    widgets.add(InfoLineWidget("announcements".tr(), ""));

    return widgets;
  }

  ///Helper to get list of announcements from this course
  List<Widget> _gatherAnnouncements(List<News> news) {
    List<Widget> widgets = <Widget>[];

    if (news.isEmpty) {
      widgets.add(Nothing());
    }

    news.forEach((news) {
      String body = StringUtil.removeHTMLTags(news.body);

      widgets.add(Announcement(title: news.topic, time: news.chdate, body: body));
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    Future<List<News>> news = Provider.of<NewsProvider>(context).get(course.courseID);

    return Scaffold(
      appBar: AppBar(
        title: Text("info".tr() + ": " + course.title, style: GoogleFonts.montserrat()),
        backgroundColor: course.color,
      ),
      body: FutureBuilder(
        future: news,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                ),
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  children: _gatherInfo() + _gatherAnnouncements(snapshot.data),
                ),
              ),
              onRefresh: () async {
                return Provider.of<NewsProvider>(context, listen: false).forceUpdate(course.courseID);
              },
            );
          } else {
            return Container(
              child: LinearProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
