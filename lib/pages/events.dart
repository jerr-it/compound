import 'package:flutter/material.dart';
import 'package:fludip/navdrawer/navdrawer.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Veranstaltungen"),
      ),
      body: Center(
        child: Text("Veranstaltungen page here"),
      ),
      drawer: NavDrawer(),
    );
  }
}
