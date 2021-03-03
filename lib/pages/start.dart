import 'package:flutter/material.dart';
import 'package:fludip/navdrawer/navdrawer.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Start"),
      ),
      body: Center(
        child: Text("This is the start page"),
      ),
      drawer: NavDrawer()
    );
  }
}
