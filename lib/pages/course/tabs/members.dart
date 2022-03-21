import 'package:compound/provider/course/courseModel.dart';
import 'package:compound/provider/course/members/memberModel.dart';
import 'package:compound/provider/course/members/membersProvider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Compound - Mobile StudIP client
// Copyright (C) 2021 Jerrit Gläsker

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

///List of members of a course.
///Grouped by lecturer, tutor and student
class MembersTab extends StatelessWidget {
  final Course _course;

  MembersTab({@required course}) : _course = course;

  List<Widget> _buildMembersList(Members members) {
    List<Widget> widgets = <Widget>[];

    if (members.lecturers.isNotEmpty) {
      widgets.add(Text(
        "lecturers".tr(),
        style: TextStyle(
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
          title: Text(lecturer.formattedName),
        ));
      });
    }

    if (members.tutors.isNotEmpty) {
      widgets.add(Text(
        "tutors".tr(),
        style: TextStyle(
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
          title: Text(tutor.formattedName),
        ));
      });
    }

    if (members.studends.isNotEmpty) {
      widgets.add(Text(
        "students".tr(),
        style: TextStyle(
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
          title: Text(student.formattedName),
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("members".tr()),
            Hero(
              tag: "members".tr(),
              child: Icon(Icons.people),
            )
          ],
        ),
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
          }

          if (snapshot.hasError) {
            return RefreshIndicator(
              child: ErrorWidget(snapshot.error.toString()),
              onRefresh: () async {
                return Provider.of<MembersProvider>(context, listen: false).forceUpdate(_course.courseID);
              },
            );
          }

          return Container(
            child: LinearProgressIndicator(),
          );
        },
      ),
    );
  }
}
