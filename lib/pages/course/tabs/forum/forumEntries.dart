import 'package:compound/pages/course/tabs/forum/forumEntryWidget.dart';
import 'package:compound/pages/course/tabs/forum/forumReply.dart';
import 'package:compound/provider/course/courseModel.dart';
import 'package:compound/provider/course/forum/entryModel.dart';
import 'package:compound/provider/course/forum/forumProvider.dart';
import 'package:compound/util/widgets/Nothing.dart';
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

///Displays the entries of a forum topic
class ForumEntriesViewer extends StatelessWidget {
  final String _pageTitle;
  final Course _course;

  final int _categoryIdx;
  final int _areaIdx;
  final int _topicIdx;

  ForumEntriesViewer({@required pageTitle, @required course, @required categoryIdx, @required areaIdx, @required topicIdx})
      : _pageTitle = pageTitle,
        _course = course,
        _categoryIdx = categoryIdx,
        _areaIdx = areaIdx,
        _topicIdx = topicIdx;

  List<Widget> _buildEntryList(List<ForumEntry> entries) {
    List<Widget> widgets = <Widget>[];
    if (entries.isEmpty) {
      return <Widget>[Nothing()];
    }

    entries.forEach((entry) {
      widgets.add(ForumEntryWidget(entry));
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    Future<List<ForumEntry>> entries = Provider.of<ForumProvider>(context).getEntries(
      context,
      _course.courseID,
      _categoryIdx,
      _areaIdx,
      _topicIdx,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitle),
        backgroundColor: _course.color,
      ),
      body: FutureBuilder(
        future: entries,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              child: Container(
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  children: _buildEntryList(snapshot.data),
                ),
              ),
              onRefresh: () async {
                return Provider.of<ForumProvider>(context, listen: false)
                    .forceUpdateEntries(context, _course.courseID, _categoryIdx, _areaIdx, _topicIdx);
              },
            );
          }

          if (snapshot.hasError) {
            return RefreshIndicator(
              child: ErrorWidget(snapshot.error.toString()),
              onRefresh: () async {
                return Provider.of<ForumProvider>(context, listen: false)
                    .forceUpdateEntries(context, _course.courseID, _categoryIdx, _areaIdx, _topicIdx);
              },
            );
          }

          return Container(
            child: LinearProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String reply = await Navigator.push(context, MaterialPageRoute(builder: (context) => ForumReplyScreen()));
          if (reply == null) {
            return;
          }

          try {
            await Provider.of<ForumProvider>(context, listen: false)
                .sendReply(_course.courseID, _categoryIdx, _areaIdx, _topicIdx, reply);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
          }
        },
        tooltip: "Write reply",
        child: Icon(Icons.reply),
      ),
    );
  }
}
