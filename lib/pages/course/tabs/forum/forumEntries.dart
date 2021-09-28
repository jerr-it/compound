import 'dart:convert';

import 'package:fludip/pages/course/tabs/forum/forumReply.dart';
import 'package:fludip/provider/course/forum/entryModel.dart';
import 'package:fludip/provider/course/forum/forumProvider.dart';
import 'package:fludip/provider/course/overview/courseModel.dart';
import 'package:fludip/util/str.dart';
import 'package:fludip/util/widgets/Nothing.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
                  style: GoogleFonts.montserrat(fontWeight: FontWeight.w300),
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
                  style: GoogleFonts.montserrat(),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    StringUtil.fromUnixTime(entry.mkdate * 1000, "dd.MM.yyyy HH:mm"),
                    style: GoogleFonts.montserrat(fontWeight: FontWeight.w200),
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
        title: Text(_pageTitle, style: GoogleFonts.montserrat()),
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
          if (reply == null) {
            return;
          }

          try {
            Response response = await Provider.of<ForumProvider>(context, listen: false)
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
