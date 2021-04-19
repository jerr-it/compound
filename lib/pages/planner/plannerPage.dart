import 'package:fludip/pages/planner/scheduleView.dart';
import 'package:flutter/material.dart';
import 'package:fludip/navdrawer/navDrawer.dart';

class PlannerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Planer"),
      ),
      body: ScheduleViewer(),
      drawer: NavDrawer(),
    );
  }
}
