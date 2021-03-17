import 'package:flutter/material.dart';
import 'package:fludip/navdrawer/navDrawer.dart';

class MessagesPage extends StatefulWidget {
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nachrichten"),
      ),
      body: Center(
        child: Text("Nachrichten page here"),
      ),
      drawer: NavDrawer(),
    );
  }
}
