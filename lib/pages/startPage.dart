import 'package:fludip/provider/globalNewsProvider.dart';
import 'package:fludip/util/str.dart';
import 'package:flutter/material.dart';
import 'package:fludip/navdrawer/navDrawer.dart';
import 'package:intl/intl.dart';
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

    final DateFormat formatter = DateFormat("dd.MM.yyyy HH:mm");

    news.forEach((newsKey, newsData) {
      String topic = newsData["topic"].toString();
      String body = StringUtil.removeHTMLTags(newsData["body"].toString());

      DateTime dateTime = new DateTime.fromMillisecondsSinceEpoch(int.parse(newsData["date"].toString()) * 1000);
      String date = formatter.format(dateTime);

      widgets.add(Card(
        child: ExpansionTile(
          title: Container(
            child: Row(
              children: [
                FlutterLogo(
                  size: 32,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        topic,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        date,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: Text(body),
            )
          ],
        ),
      ));
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
