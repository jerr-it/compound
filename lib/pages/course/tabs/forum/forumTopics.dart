import 'package:fludip/navdrawer/navDrawer.dart';
import 'package:fludip/pages/course/tabs/forum/forumEntries.dart';
import 'package:fludip/provider/course/forum/forumProvider.dart';
import 'package:fludip/provider/course/forum/topicModel.dart';
import 'package:fludip/provider/course/overview/courseModel.dart';
import 'package:fludip/util/colorMapper.dart';
import 'package:fludip/util/str.dart';
import 'package:fludip/util/widgets/Nothing.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        title: Text(title),
        subtitle: Text(subtitle),
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

      widgets.add(Divider());
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    Future<List<ForumTopic>> topics =
        Provider.of<ForumProvider>(context).getTopics(_course.courseID, _categoryIdx, _areaIdx);

    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitle),
        backgroundColor: ColorMapper.convert(_course.group),
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
                    .forceUpdateTopics(_course.courseID, _categoryIdx, _areaIdx);
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
