import 'package:fludip/provider/globalNewsProvider.dart';
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
    Map<String, dynamic> news = Provider.of<GlobalNewsProvider>(context).get()["collection"];
    List<Widget> widgets = <Widget>[];
    if (news == null) {
      return widgets;
    }

    news.forEach((newsKey, newsData) {
      String topic = newsData["topic"].toString();
      int timeStamp = int.parse(newsData["date"].toString()) * 1000;
      String body = StringUtil.removeHTMLTags(newsData["body"].toString());

      widgets.add(CommonWidgets.announcement(topic, timeStamp, body));
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
          Provider.of<GlobalNewsProvider>(context, listen: false).update();
          return Future<void>.value(null);
        },
      ),
      drawer: NavDrawer(),
    );
  }
}
