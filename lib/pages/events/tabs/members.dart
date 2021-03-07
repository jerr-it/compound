import 'package:flutter/material.dart';

class MembersTab extends StatefulWidget {
  final String _courseID;

  MembersTab({@required courseID})
      : _courseID = courseID;

  @override
  _MembersTabState createState() => _MembersTabState();
}

class _MembersTabState extends State<MembersTab> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
