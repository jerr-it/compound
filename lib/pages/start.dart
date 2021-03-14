import 'dart:convert';

import 'package:fludip/net/fakeclient.dart';
import 'package:flutter/material.dart';
import 'package:fludip/navdrawer/navdrawer.dart';
import 'package:intl/intl.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {

  Map<String,dynamic> _news;

  @override
  void initState() {
    _fetchNews();
    super.initState();
  }

  ///Fetch the data from the web
  void _fetchNews() async {
    var client = FakeClient();
    var jsond = await client.doRoute("/studip/news");
    setState(() {
      _news = jsonDecode(jsond);
    });
  }

  ///Convert data to widgets
  List<Widget> _buildListEntries(){
    if(_news == null){
      var ret = <Widget>[];
      ret.add(Center(
          child:ListTile(
            title: Text("No news found!"),
            subtitle: Text("Check again later..."),
          )
        )
      );
      return ret;
    }

    Map<String, dynamic> news = _news["collection"];
    List<Widget> widgets = <Widget>[];

    final DateFormat formatter = DateFormat("dd.MM.yyyy HH:mm");

    news.forEach((newsKey, newsData) {
      String topic = newsData["topic"].toString();
      String body = newsData["body"].toString();

      DateTime dateTime = new DateTime.fromMillisecondsSinceEpoch(int.parse(newsData["date"].toString()) * 1000);
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Start"),
      ),
      body: RefreshIndicator(
        child: ListView(
          children: _buildListEntries(),
        ),
        onRefresh: (){
          _fetchNews();
          return Future<void>.value(null);
        },
      ),
      drawer: NavDrawer()
    );
  }
}
