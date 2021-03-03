import 'package:flutter/material.dart';
import 'package:fludip/navdrawer/navdrawer.dart';

class BlackboardPage extends StatefulWidget {
  @override
  _BlackboardPageState createState() => _BlackboardPageState();
}

class _BlackboardPageState extends State<BlackboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Schwarzes Brett"),
        ),
        body: Center(
          child: Text("This is the schwarzes Brett page"),
        ),
        drawer: NavDrawer()
    );
  }
}
