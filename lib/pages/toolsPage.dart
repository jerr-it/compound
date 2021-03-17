import 'package:flutter/material.dart';
import 'package:fludip/navdrawer/navDrawer.dart';

class ToolsPage extends StatefulWidget {
  @override
  _ToolsPageState createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Tools"),
        ),
        body: Center(
          child: Text("This is the tools page"),
        ),
        drawer: NavDrawer()
    );
  }
}
