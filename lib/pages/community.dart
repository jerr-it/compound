import 'package:flutter/material.dart';
import 'package:fludip/navdrawer/navdrawer.dart';

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Community"),
        ),
        body: Center(
          child: Text("This is the community page"),
        ),
        drawer: NavDrawer()
    );
  }
}
