import 'dart:convert';
import 'dart:math';

import 'package:fludip/net/fakeclient.dart';
import 'package:flutter/material.dart';
import 'package:fludip/navdrawer/navdrawer.dart';
import 'package:flutter/services.dart';

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
    var jsond = await client.doRoute("/news");
    setState(() {
      _news = jsonDecode(jsond);
    });
  }

  ///Convert data to widgets
  List<Widget> _createListEntries(){
    if(_news == null){
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

    List<dynamic> news = _news["news"];

    return news.map((newsObject) {
      var title = newsObject["topic"].toString();
      var body = newsObject["body"].toString();

      var subTitleLen = body.length;
      if (subTitleLen >= 40){
        subTitleLen = 40;
      }

      return Card(
        child: ExpansionTile(
          title: Container(
            child: Row(
              children: [
                FlutterLogo(size: 32,),
                Flexible(
                  child: Text(
                    title,
                    //overflow: TextOverflow.ellipsis,
                  )
                )
              ],
            ),
          ),
          trailing: Icon(Icons.arrow_drop_down),
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: Text(body),
            )
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Start"),
      ),
      body: RefreshIndicator(
        child: ListView(
          children: _createListEntries(),
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
