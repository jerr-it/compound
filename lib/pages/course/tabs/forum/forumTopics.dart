import 'package:compound/navdrawer/navDrawer.dart';
import 'package:compound/pages/course/tabs/forum/forumEntries.dart';
import 'package:compound/provider/course/courseModel.dart';
import 'package:compound/provider/course/forum/forumProvider.dart';
import 'package:compound/provider/course/forum/topicModel.dart';
import 'package:compound/util/str.dart';
import 'package:compound/util/widgets/Nothing.dart';
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

///Displays topics of a forum area
class ForumTopicsViewer extends StatelessWidget {
  final String _pageTitle;
  final int _categoryIdx;
  final int _areaIdx;

  final Course _course;

  ForumTopicsViewer({@required title, @required categoryIdx, @required areaIdx, @required course})
      : _pageTitle = title,
        _categoryIdx = categoryIdx,
        _areaIdx = areaIdx,
        _course = course;

  List<Widget> _buildTopicList(BuildContext context, List<ForumTopic> topics) {
    List<Widget> widgets = <Widget>[];

    if (topics.isEmpty) {
      return <Widget>[Nothing()];
    }

    for (int topicIdx = 0; topicIdx < topics.length; topicIdx++) {
      String title = StringUtil.removeHTMLTags(topics[topicIdx].subject.replaceAll("\n", ""));
      String subtitle = StringUtil.removeHTMLTags(topics[topicIdx].content.replaceAll("\n", ""));

      widgets.add(ListTile(
        leading: Icon(Icons.forum, size: 30),
        title: Text(title, style: GoogleFonts.montserrat()),
        subtitle: Text(subtitle, style: GoogleFonts.montserrat()),
        onTap: () async {
          Navigator.push(
            context,
            navRoute(
              ForumEntriesViewer(
                pageTitle: title,
                course: _course,
                categoryIdx: _categoryIdx,
                areaIdx: _areaIdx,
                topicIdx: topicIdx,
              ),
            ),
          );
        },
      ));
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    Future<List<ForumTopic>> topics =
        Provider.of<ForumProvider>(context).getTopics(context, _course.courseID, _categoryIdx, _areaIdx);

    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitle, style: GoogleFonts.montserrat()),
        backgroundColor: _course.color,
      ),
      body: FutureBuilder(
        future: topics,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              child: Container(
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  children: _buildTopicList(context, snapshot.data),
                ),
              ),
              onRefresh: () async {
                return Provider.of<ForumProvider>(context, listen: false)
                    .forceUpdateTopics(context, _course.courseID, _categoryIdx, _areaIdx);
              },
            );
          }

          if (snapshot.hasError) {
            return RefreshIndicator(
              child: ErrorWidget(snapshot.error.toString()),
              onRefresh: () async {
                return Provider.of<ForumProvider>(context, listen: false)
                    .forceUpdateTopics(context, _course.courseID, _categoryIdx, _areaIdx);
              },
            );
          }

          return Container(
            child: LinearProgressIndicator(),
          );
        },
      ),
    );
  }
}
