import 'package:flutter/material.dart';
import 'package:fludip/navdrawer/navDrawer.dart';

class PlannerPage extends StatefulWidget {
  @override
  _PlannerPageState createState() => _PlannerPageState();
}

class _PlannerPageState extends State<PlannerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Planer"),
        ),
        body: Center(
          child: Text("This is the planer page"),
        ),
        drawer: NavDrawer()
    );
  }
}
