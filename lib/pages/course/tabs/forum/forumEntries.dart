import 'package:fludip/provider/course/forum/entryModel.dart';
import 'package:fludip/provider/course/forum/forumProvider.dart';
import 'package:fludip/provider/course/overview/courseModel.dart';
import 'package:fludip/util/colorMapper.dart';
import 'package:fludip/util/commonWidgets.dart';
import 'package:fludip/util/str.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///TODO show user and time stamp
class ForumEntriesViewer extends StatelessWidget {
  final String pageTitle;
  final Course course;

  final int categoryIdx;
  final int areaIdx;
  final int topicIdx;

  ForumEntriesViewer({@required pageTitle, @required course, @required categoryIdx, @required areaIdx, @required topicIdx})
      : pageTitle = pageTitle,
        course = course,
        categoryIdx = categoryIdx,
        areaIdx = areaIdx,
        topicIdx = topicIdx;

  List<Widget> _buildEntryList(List<ForumEntry> entries) {
    List<Widget> widgets = <Widget>[];
    if (entries.isEmpty) {
      return <Widget>[CommonWidgets.nothing()];
    }

    entries.forEach((entry) {
      widgets.add(ListTile(
        leading: Icon(Icons.person, size: 30),
        title: Text(StringUtil.removeHTMLTags(entry.content.replaceAll("\n", ""))),
      ));
      widgets.add(Divider());
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    Future<List<ForumEntry>> entries = Provider.of<ForumProvider>(context).getEntries(
      course.courseID,
      categoryIdx,
      areaIdx,
      topicIdx,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
        backgroundColor: ColorMapper.convert(course.group),
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
                    .forceUpdateEntries(course.courseID, categoryIdx, areaIdx, topicIdx);
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
