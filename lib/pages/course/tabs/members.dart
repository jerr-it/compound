import 'package:fludip/provider/course/members/memberModel.dart';
import 'package:fludip/provider/course/members/membersProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MembersTab extends StatefulWidget {
  String _courseID;
  Color _color;

  Members _members;

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

    if (widget._members.lecturers.isNotEmpty) {
      widgets.add(Text(
        "Lecturers",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ));

      widget._members.lecturers.forEach((lecturer) {
        widgets.add(ListTile(
          leading: Image.network(
            lecturer.avatarUrlNormal,
            width: 30,
            height: 30,
          ),
          title: Text(lecturer.formattedName),
        ));
      });
    }

    if (widget._members.tutors.isNotEmpty) {
      widgets.add(Text(
        "Tutors",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ));

      widget._members.tutors.forEach((tutor) {
        widgets.add(ListTile(
          leading: Image.network(
            tutor.avatarUrlNormal,
            width: 30,
            height: 30,
          ),
          title: Text(tutor.formattedName),
        ));
      });
    }

    if (widget._members.studends.isNotEmpty) {
      widgets.add(Text(
        "Students",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ));

      widget._members.studends.forEach((student) {
        widgets.add(ListTile(
          leading: Image.network(
            student.avatarUrlNormal,
            width: 30,
            height: 30,
          ),
          title: Text(student.formattedName),
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
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            children: _buildMembersList(),
          ),
        ),
        onRefresh: () async {
          await Provider.of<MembersProvider>(context, listen: false).update(widget._courseID);
          return Future<void>.value(null);
        },
      ),
    );
  }
}
