import 'package:fludip/provider/course/membersProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MembersTab extends StatefulWidget {
  String _courseID;

  Map<String, dynamic> _members;

  MembersTab({@required courseID}) :
      _courseID = courseID;

  @override
  _MembersTabState createState() => _MembersTabState();
}

class _MembersTabState extends State<MembersTab> {
  @override
  Widget build(BuildContext context) {
    widget._members = Provider.of<MembersProvider>(context).getMembers(widget._courseID);

    return Scaffold(
      appBar: AppBar(
        title: Text("Members"),
      ),
      body: Container(),
    );
  }
}
