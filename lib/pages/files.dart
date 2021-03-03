import 'package:flutter/material.dart';
import 'package:fludip/navdrawer/navdrawer.dart';

class FilePage extends StatefulWidget {
  @override
  _FilePageState createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Dateien"),
        ),
        body: Center(
          child: Text("This is the Dateien page"),
        ),
        drawer: NavDrawer()
    );
  }
}
