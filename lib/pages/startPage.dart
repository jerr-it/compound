import 'package:fludip/provider/news/globalNewsProvider.dart';
import 'package:fludip/provider/news/newsModel.dart';
import 'package:fludip/util/commonWidgets.dart';
import 'package:fludip/util/str.dart';
import 'package:flutter/material.dart';
import 'package:fludip/navdrawer/navDrawer.dart';
import 'package:provider/provider.dart';

class StartPage extends StatelessWidget {
  ///Convert data to widgets
  List<Widget> _buildListEntries(List<News> announcements) {
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
    Future<List<News>> news = Provider.of<NewsProvider>(context).get("global");

    return Scaffold(
      appBar: AppBar(
        title: Text("Start"),
      ),
      body: FutureBuilder(
        future: news,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
                child: ListView(
                  children: _buildListEntries(snapshot.data),
                ),
                onRefresh: () {
                  return Provider.of<NewsProvider>(context, listen: false).forceUpdate("global");
                });
          } else {
            return Container(
              child: LinearProgressIndicator(),
            );
          }
        },
      ),
      drawer: NavDrawer(),
    );
  }
}
