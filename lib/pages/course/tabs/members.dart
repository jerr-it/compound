import 'package:fludip/provider/course/membersProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MembersTab extends StatefulWidget {
  String _courseID;
  Color _color;

  Map<String, dynamic> _members;

  MembersTab({@required courseID, @required color})
      : _courseID = courseID,
        _color = color;

  @override
  _MembersTabState createState() => _MembersTabState();
}

class _MembersTabState extends State<MembersTab> {
  List<Widget> _buildMembersList() {
    List<Widget> widgets = <Widget>[];
    if (widget._members == null) {
      return widgets;
    }

    if (widget._members.containsKey("dozent")) {
      widgets.add(Text(
        "Lecturers",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ));

      widget._members["dozent"].forEach((lecturerIDUrl, lecturerData) {
        widgets.add(ListTile(
          leading: Icon(Icons.person, size: 30),
          title: Text(lecturerData["member"]["name"]["formatted"]),
        ));
      });
    }

    if (widget._members.containsKey("tutor")) {
      widgets.add(Text(
        "Tutors",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ));

      widget._members["tutor"].forEach((tutorIDUrl, tutorData) {
        widgets.add(ListTile(
          leading: Icon(Icons.person, size: 30),
          title: Text(tutorData["member"]["name"]["formatted"]),
        ));
      });
    }

    if (widget._members.containsKey("autor")) {
      widgets.add(Text(
        "Students",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ));

      widget._members["autor"].forEach((autorIDUrl, autorData) {
        widgets.add(ListTile(
          leading: Icon(Icons.person, size: 30),
          title: Text(autorData["member"]["name"]["formatted"]),
        ));
      });
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    widget._members = Provider.of<MembersProvider>(context).getMembers(widget._courseID);

    return Scaffold(
      appBar: AppBar(
        title: Text("Members"),
        backgroundColor: widget._color,
      ),
      body: RefreshIndicator(
        child: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: _buildMembersList(),
          ),
        ),
        onRefresh: () async {
          Provider.of<MembersProvider>(context, listen: false).update(widget._courseID);
          return Future<void>.value(null);
        },
      ),
    );
  }
}
