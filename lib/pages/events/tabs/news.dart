import 'dart:convert';

import 'package:fludip/net/fakeclient.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewsTab extends StatefulWidget {
  final String _courseID;

  NewsTab({@required courseID})
  : _courseID = courseID;

  @override
  _NewsTabState createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> {
  Map<String,dynamic> _newsData;

  @override
  void initState() {
    _fetchNews();
    super.initState();
  }

  void _fetchNews() async {
    var client = FakeClient();
    var jsond = await client.doRoute("/course/" + widget._courseID + "/news");
    setState(() {
      _newsData = jsonDecode(jsond);
    });
  }

  List<Widget> _buildListEntries(){
    if(_newsData == null){
      var ret = List<Widget>();
      ret.add(Center(
          child:ListTile(
            title: Text("No news found!"),
            subtitle: Text("Check again later..."),
          )
      )
      );
      return ret;
    }

    Map<String, dynamic> news = _newsData["collection"];
    List<Widget> widgets = List<Widget>();

    final DateFormat formatter = DateFormat("dd.MM.yyyy HH:mm");

    news.forEach((newsID, newsObject) {
      String topic = newsObject["topic"].toString();
      String body = newsObject["body"].toString();

      DateTime dateTime = new DateTime.fromMillisecondsSinceEpoch(int.parse(newsObject["date"].toString()) * 1000);
      String date = formatter.format(dateTime);

      widgets.add(Card(
        child: ExpansionTile(
          title: Container(
            child: Row(
              children: [
                FlutterLogo(size: 32,),
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
                    )
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
    return RefreshIndicator(
      child: ListView(
        children: _buildListEntries(),
      ),
      onRefresh: (){
        _fetchNews();
        return Future<void>.value(null);
      },
    );
  }
}
