import 'package:fludip/provider/course/overview/courseModel.dart';
import 'package:fludip/provider/news/globalNewsProvider.dart';
import 'package:fludip/provider/news/newsModel.dart';
import 'package:fludip/util/colorMapper.dart';
import 'package:fludip/util/str.dart';
import 'package:fludip/util/widgets/Announcement.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class NewsTab extends StatelessWidget {
  final Course course;

  NewsTab({@required course}) : course = course;

  ///Helper to get list of announcements from this course
  List<Widget> _gatherAnnouncements(List<News> news) {
    List<Widget> widgets = <Widget>[];

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
        title: Text("news".tr() + ": " + course.title),
        backgroundColor: ColorMapper.convert(course.group),
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
                  children: _gatherAnnouncements(snapshot.data),
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
