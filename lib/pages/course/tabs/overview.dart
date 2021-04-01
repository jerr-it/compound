import 'package:fludip/pages/course/colorMapper.dart';
import 'package:fludip/provider/course/overview/courseModel.dart';
import 'package:fludip/provider/news/newsModel.dart';
import 'package:fludip/util/commonWidgets.dart';
import 'package:fludip/util/str.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NewsTab extends StatefulWidget {
  final Course _course;

  NewsTab({@required data}) : _course = data;

  @override
  _NewsTabState createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> {
  ///Helper to get list of announcements from this course
  List<Widget> _gatherAnnouncements() {
    List<Widget> widgets = <Widget>[];

    List<News> announcements = widget._course.news;
    announcements.forEach((news) {
      String body = StringUtil.removeHTMLTags(news.body);

      widgets.add(CommonWidgets.announcement(news.topic, news.chdate, body));
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News: " + widget._course.title),
        backgroundColor: ColorMapper.convert(widget._course.group),
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
        ),
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          children: _gatherAnnouncements(),
        ),
      ),
    );
  }
}
