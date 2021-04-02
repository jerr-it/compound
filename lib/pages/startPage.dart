import 'package:fludip/navdrawer/scheduleDrawer.dart';
import 'package:fludip/provider/news/globalNewsProvider.dart';
import 'package:fludip/provider/news/newsModel.dart';
import 'package:fludip/util/commonWidgets.dart';
import 'package:fludip/util/str.dart';
import 'package:flutter/material.dart';
import 'package:fludip/navdrawer/navDrawer.dart';
import 'package:provider/provider.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  ///Convert data to widgets
  List<Widget> _buildListEntries() {
    List<News> announcements = Provider.of<NewsProvider>(context).get("global");
    List<Widget> widgets = <Widget>[];
    if (announcements == null) {
      return widgets;
    }

    announcements.forEach((news) {
      String body = StringUtil.removeHTMLTags(news.body.toString());

      widgets.add(CommonWidgets.announcement(news.topic, news.chdate, body));
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Start"),
      ),
      body: RefreshIndicator(
        child: ListView(
          children: _buildListEntries(),
        ),
        onRefresh: () async {
          Provider.of<NewsProvider>(context, listen: false).update("global");
          return Future<void>.value(null);
        },
      ),
      drawer: NavDrawer(),
      endDrawer: ScheduleDrawer(),
    );
  }
}
