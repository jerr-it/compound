import 'package:compound/navdrawer/navDrawer.dart';
import 'package:compound/pages/course/page/courseListTile.dart';
import 'package:compound/provider/course/courseModel.dart';
import 'package:compound/provider/course/courseProvider.dart';
import 'package:compound/provider/course/semester/semesterFilter.dart';
import 'package:compound/provider/course/semester/semesterModel.dart';
import 'package:compound/provider/course/semester/semesterProvider.dart';
import 'package:compound/util/widgets/Nothing.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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

///Displays all the users courses, filtered by semester
class CoursePage extends StatefulWidget {
  CoursePage(BuildContext ctx, String uID)
      : _userID = uID,
        _ctx = ctx;

  final BuildContext _ctx;
  final String _userID;
  final SlidableController _slideController = new SlidableController();

  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  SemesterFilter filter;

  @override
  void initState() {
    filter = Provider.of<SemesterProvider>(this.widget._ctx, listen: false).filterOptions[1];
    super.initState();
  }

  List<Widget> _buildListEntries(BuildContext context, List<Course> courses) {
    if (courses == null || courses.isEmpty) {
      return <Widget>[Nothing()];
    }

    List<Widget> widgets = <Widget>[];

    Semester current =
        Provider.of<SemesterProvider>(context, listen: false).get(SemesterFilter(FilterType.CURRENT, null)).first;
    widgets.add(Text(
      current.title,
      style: TextStyle(fontWeight: FontWeight.w300),
      textAlign: TextAlign.center,
    ));

    courses.forEach((course) {
      if (course.endSemester == null) {
        course.endSemester =
            Provider.of<SemesterProvider>(context, listen: false).get(SemesterFilter(FilterType.CURRENT, null)).first;
      }

      if (course.endSemester.semesterID != current.semesterID ?? null) {
        widgets.add(Text(
          course.endSemester.title,
          style: TextStyle(fontWeight: FontWeight.w300),
          textAlign: TextAlign.center,
        ));
        current = course.endSemester;
      }

      widgets.add(CourseListTile(this.widget._slideController, course));
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    List<Semester> semesters = Provider.of<SemesterProvider>(context, listen: false).get(filter);
    semesters.removeWhere((element) => element == null); //Next semester might not exist (yet) and therefore will be null
    Future<List<Course>> fCourses = Provider.of<CourseProvider>(context).get(context, this.widget._userID, semesters);

    return Scaffold(
      appBar: AppBar(
        title: Text("event".tr()),
        bottom: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 50),
          child: DropdownButton<SemesterFilter>(
            items: Provider.of<SemesterProvider>(context, listen: false).filterOptions.map(
              (SemesterFilter filter) {
                return DropdownMenuItem<SemesterFilter>(
                  value: filter,
                  child: Text(
                    filter.id == null //Translate only the special filter types
                        ? filter.type.toString().tr()
                        : Provider.of<SemesterProvider>(context, listen: false).get(filter).first.title,
                  ),
                );
              },
            ).toList(),
            value: filter,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            underline: Container(
              height: 2,
              color: Colors.black,
            ),
            onChanged: (SemesterFilter newFilter) {
              setState(() {
                filter = newFilter;
                Provider.of<CourseProvider>(context, listen: false).pushSemesterFilter(filter);
              });
            },
          ),
        ),
      ),
      body: FutureBuilder(
        future: fCourses,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: RefreshIndicator(
                child: ListView(
                  children: _buildListEntries(context, snapshot.data),
                ),
                onRefresh: () async {
                  return Provider.of<CourseProvider>(context, listen: false)
                      .forceUpdate(context, this.widget._userID, semesters);
                },
              ),
            );
          }

          if (snapshot.hasError) {
            return RefreshIndicator(
              child: ErrorWidget(snapshot.error.toString()),
              onRefresh: () async {
                return Provider.of<CourseProvider>(context, listen: false)
                    .forceUpdate(context, this.widget._userID, semesters);
              },
            );
          }

          return Container(
            child: LinearProgressIndicator(),
          );
        },
      ),
      drawer: NavDrawer(),
    );
  }
}
