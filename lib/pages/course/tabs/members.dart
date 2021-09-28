import 'package:fludip/provider/course/members/memberModel.dart';
import 'package:fludip/provider/course/members/membersProvider.dart';
import 'package:fludip/provider/course/overview/courseModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class MembersTab extends StatelessWidget {
  final Course _course;

  MembersTab({@required course}) : _course = course;

  List<Widget> _buildMembersList(Members members) {
    List<Widget> widgets = <Widget>[];

    if (members.lecturers.isNotEmpty) {
      widgets.add(Text(
        "lecturers".tr(),
        style: GoogleFonts.montserrat(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ));

      members.lecturers.forEach((lecturer) {
        widgets.add(ListTile(
          leading: Image.network(
            lecturer.avatarUrlNormal,
            width: 30,
            height: 30,
          ),
          title: Text(lecturer.formattedName, style: GoogleFonts.montserrat()),
        ));
      });
    }

    if (members.tutors.isNotEmpty) {
      widgets.add(Text(
        "tutors".tr(),
        style: GoogleFonts.montserrat(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ));

      members.tutors.forEach((tutor) {
        widgets.add(ListTile(
          leading: Image.network(
            tutor.avatarUrlNormal,
            width: 30,
            height: 30,
          ),
          title: Text(tutor.formattedName, style: GoogleFonts.montserrat()),
        ));
      });
    }

    if (members.studends.isNotEmpty) {
      widgets.add(Text(
        "students".tr(),
        style: GoogleFonts.montserrat(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ));

      members.studends.forEach((student) {
        widgets.add(ListTile(
          leading: Image.network(
            student.avatarUrlNormal,
            width: 30,
            height: 30,
          ),
          title: Text(student.formattedName, style: GoogleFonts.montserrat()),
        ));
      });
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    Future<Members> members = Provider.of<MembersProvider>(context).get(_course.courseID);

    return Scaffold(
      appBar: AppBar(
        title: Text("members".tr(), style: GoogleFonts.montserrat()),
        backgroundColor: _course.color,
      ),
      body: FutureBuilder(
        future: members,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              child: Container(
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  children: _buildMembersList(snapshot.data),
                ),
              ),
              onRefresh: () async {
                return Provider.of<MembersProvider>(context, listen: false).forceUpdate(_course.courseID);
              },
            );
          } else {
            return Container(
              child: LinearProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
