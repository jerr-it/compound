import 'package:flutter/material.dart';
import 'package:fludip/navdrawer/navDrawer.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Suche"),
      ),
      body: Center(
        child: Text("This is the suche page"),
      ),
      drawer: NavDrawer(),
    );
  }
}
