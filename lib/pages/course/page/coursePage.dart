import 'package:fludip/pages/course/page/courseListTile.dart';
import 'package:fludip/provider/course/semester/semesterFilter.dart';
import 'package:fludip/provider/course/semester/semesterModel.dart';
import 'package:fludip/provider/course/courseModel.dart';
import 'package:fludip/provider/course/courseProvider.dart';
import 'package:fludip/provider/course/semester/semesterProvider.dart';
import 'package:fludip/util/dialogs/confirmDialog.dart';
import 'package:fludip/util/widgets/Nothing.dart';
import 'package:flutter/material.dart';
import 'package:fludip/navdrawer/navDrawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;

class CoursePage extends StatefulWidget {
  CoursePage(BuildContext ctx, String uID)
      : _userID = uID,
        _ctx = ctx;

  BuildContext _ctx;
  String _userID;
  SemesterFilter filter;

  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  @override
  void initState() {
    this.widget.filter = Provider.of<SemesterProvider>(this.widget._ctx, listen: false).filterOptions[1];
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
      style: GoogleFonts.montserrat(fontWeight: FontWeight.w300),
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
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w300),
          textAlign: TextAlign.center,
        ));
        current = course.endSemester;
      }

      //Ugly, but https://github.com/flutter/flutter/issues/81931 is still open
      //This means we have to check in advance if the url is a valid image resource
      //since it doesn't appear possible to handle the error somehow
      //Both wrapping in try-catch and using the errorBuilder don't work
      String url = Provider.of<CourseProvider>(context, listen: false).getLogo(course.courseID);
      var response = http.get(Uri.parse(url));

      widgets.add(InkWell(
        child: CourseListTile(course, response),
        onLongPress: () {
          ConfirmDialog.display(
            context,
            title: "sure?".tr(),
            subtitle: "leave-course".tr(),
            leading: Icon(Icons.warning_sharp),
            firstOption: "confirm".tr(),
            secondOption: "cancel".tr(),
            onFirstOption: () async {
              await Provider.of<CourseProvider>(context, listen: false).signout(course.courseID);
            },
            onSecondOption: () {},
          );
        },
      ));
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    List<Semester> semesters = Provider.of<SemesterProvider>(context, listen: false).get(this.widget.filter);
    semesters.removeWhere((element) => element == null); //Next semester might not exist (yet) and therefore will be null
    Future<List<Course>> fCourses = Provider.of<CourseProvider>(context).get(context, this.widget._userID, semesters);

    return Scaffold(
      appBar: AppBar(
        title: Text("event".tr(), style: GoogleFonts.montserrat()),
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
                    style: GoogleFonts.montserrat(color: Colors.black),
                  ),
                );
              },
            ).toList(),
            value: this.widget.filter,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            style: GoogleFonts.montserrat(),
            underline: Container(
              height: 2,
              color: Colors.black,
            ),
            onChanged: (SemesterFilter newFilter) {
              setState(() {
                this.widget.filter = newFilter;
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
          } else {
            return Container(
              child: LinearProgressIndicator(),
            );
          }
        },
      ),
      drawer: NavDrawer(),
    );
  }
}
