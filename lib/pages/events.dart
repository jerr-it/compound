import 'dart:convert';

import 'package:fludip/net/fakeclient.dart';
import 'package:flutter/material.dart';
import 'package:fludip/navdrawer/navdrawer.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {

  Map<String, dynamic> _courses;

  @override
  void initState() {
    _fetchCourses();
    super.initState();
  }

  ///Fetch the users courses
  void _fetchCourses() async {
    var client = FakeClient();
    var jsond = await client.doRoute("/courses");
    setState(() {
      _courses = jsonDecode(jsond);
    });
  }

  List<Widget> _buildListEntries() {
    if(_courses == null){
      var ret = List<Widget>();
      ret.add(Container(
        margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: ListTile(
          title: Text("No courses found!"),
          subtitle: Text("Try again later..."),
        ),
      ));
      return ret;
    }

    List<dynamic> courses = _courses["courses"];

    return courses.map((courseObject) {
      var title = courseObject["title"].toString();
      var subTitle = courseObject["subtitle"].toString();
      var description = courseObject["description"].toString();
      var location = courseObject["location"].toString();

      return Card(
        child: ExpansionTile(
          title: Container(
            child: Row(
              children: [
                Container(
                  width: 5,
                  height: 50,
                  decoration: BoxDecoration(color: Colors.red),
                  child: Text(""),
                ),
                Text(title),
              ],
            ),
          ),
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: Column(
                children: [
                  Text(subTitle),
                  Text(description),
                  Text(location),
                ],
              ),
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
        title: Text("Veranstaltungen"),
      ),
      body: RefreshIndicator(
        child: ListView(
          children: _buildListEntries(),
        ),
        onRefresh: (){
          _fetchCourses();
          return Future<void>.value(null);
        },
      ),
      drawer: NavDrawer(),
    );
  }
}
