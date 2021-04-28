import 'package:fludip/navdrawer/navDrawer.dart';
import 'package:fludip/pages/course/tabs/forum/forumEntries.dart';
import 'package:fludip/provider/course/forum/forumProvider.dart';
import 'package:fludip/provider/course/forum/topicModel.dart';
import 'package:fludip/provider/course/overview/courseModel.dart';
import 'package:fludip/util/colorMapper.dart';
import 'package:fludip/util/commonWidgets.dart';
import 'package:fludip/util/str.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForumTopicsViewer extends StatelessWidget {
  final String pageTitle;
  final int categoryIdx;
  final int areaIdx;

  final Course course;

  ForumTopicsViewer({@required title, @required categoryIdx, @required areaIdx, @required course})
      : pageTitle = title,
        categoryIdx = categoryIdx,
        areaIdx = areaIdx,
        course = course;

  List<Widget> _buildTopicList(BuildContext context, List<ForumTopic> topics) {
    List<Widget> widgets = <Widget>[];

    if (topics.isEmpty) {
      return <Widget>[CommonWidgets.nothing()];
    }

    for (int topicIdx = 0; topicIdx < topics.length; topicIdx++) {
      String title = StringUtil.removeHTMLTags(topics[topicIdx].subject.replaceAll("\n", ""));
      String subtitle = StringUtil.removeHTMLTags(topics[topicIdx].content.replaceAll("\n", ""));

      widgets.add(ListTile(
        leading: Icon(Icons.forum, size: 30),
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: () async {
          Navigator.push(
            context,
            navRoute(
              ForumEntriesViewer(
                pageTitle: title,
                course: course,
                categoryIdx: categoryIdx,
                areaIdx: areaIdx,
                topicIdx: topicIdx,
              ),
            ),
          );
        },
      ));

      widgets.add(Divider());
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    Future<List<ForumTopic>> topics = Provider.of<ForumProvider>(context).getTopics(course.courseID, categoryIdx, areaIdx);

    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
        backgroundColor: ColorMapper.convert(course.group),
      ),
      body: FutureBuilder(
        future: topics,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              child: Container(
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  children: _buildTopicList(context, snapshot.data),
                ),
              ),
              onRefresh: () async {
                return Provider.of<ForumProvider>(context, listen: false)
                    .forceUpdateTopics(course.courseID, categoryIdx, areaIdx);
              },
            );
          } else {
            return Container(
              child: LinearProgressIndicator(),
            );
          }
        },
      ),
      /*
      body: */
    );
  }
}
