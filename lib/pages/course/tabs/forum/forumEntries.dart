import 'dart:convert';

import 'package:fludip/pages/course/tabs/forum/forumReply.dart';
import 'package:fludip/provider/course/forum/entryModel.dart';
import 'package:fludip/provider/course/forum/forumProvider.dart';
import 'package:fludip/provider/course/overview/courseModel.dart';
import 'package:fludip/util/str.dart';
import 'package:fludip/util/widgets/Nothing.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

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
      widgets.add(Row(
        children: [
          Flexible(
            flex: 3,
            child: Column(
              children: [
                CircleAvatar(
                  minRadius: 10,
                  maxRadius: 20,
                  backgroundImage: NetworkImage(entry.user.avatarUrlMedium),
                ),
                Text(
                  entry.user.formattedName,
                  style: TextStyle(fontWeight: FontWeight.w300),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
          VerticalDivider(),
          Flexible(
            flex: 9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  StringUtil.removeHTMLTags(entry.content.replaceAll("\n", "")),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    StringUtil.fromUnixTime(entry.mkdate * 1000, "dd.MM.yyyy HH:mm"),
                    style: TextStyle(fontWeight: FontWeight.w200),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        ],
      ));
      widgets.add(Divider());
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
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  children: _buildEntryList(snapshot.data),
                ),
              ),
              onRefresh: () async {
                return Provider.of<ForumProvider>(context, listen: false)
                    .forceUpdateEntries(context, _course.courseID, _categoryIdx, _areaIdx, _topicIdx);
              },
            );
          } else {
            return Container(
              child: LinearProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String reply = await Navigator.push(context, MaterialPageRoute(builder: (context) => ForumReplyScreen()));
          Response response = await Provider.of<ForumProvider>(context, listen: false)
              .sendReply(_course.courseID, _categoryIdx, _areaIdx, _topicIdx, reply);
          var body = jsonDecode(response.body);
          //TODO check for error
        },
        tooltip: "Write reply",
        child: Icon(Icons.reply),
      ),
    );
  }
}
