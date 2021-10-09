import 'package:compound/navdrawer/navDrawer.dart';
import 'package:compound/pages/search/coursePreviewWidget.dart';
import 'package:compound/provider/course/courseModel.dart';
import 'package:compound/provider/course/coursePreviewModel.dart';
import 'package:compound/provider/course/courseProvider.dart';
import 'package:compound/provider/course/semester/semesterFilter.dart';
import 'package:compound/provider/course/semester/semesterModel.dart';
import 'package:compound/provider/course/semester/semesterProvider.dart';
import 'package:compound/provider/user/userModel.dart';
import 'package:compound/provider/user/userProvider.dart';
import 'package:compound/util/dialogs/confirmDialog.dart';
import 'package:compound/util/widgets/styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// Fludip - Mobile StudIP client
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

class SearchPage extends StatefulWidget {
  SearchPage(String userID) : _userID = userID;

  String _searchTerm;

  final TextEditingController _controller = new TextEditingController();
  final String _userID;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Widget> _buildSearchResults(BuildContext context, List<CoursePreview> courses, List<Course> signedUpCourses) {
    List<Widget> widgets = <Widget>[];

    courses.forEach((CoursePreview preview) {
      widgets.add(Row(
        children: [
          Expanded(child: CoursePreviewWidget(preview)),
          signedUpCourses.firstWhere((sCourse) => sCourse.courseID == preview.courseID, orElse: () => null) == null
              ? Container(
                  child: ElevatedButton(
                    onPressed: () {
                      ConfirmDialog.display(
                        context,
                        title: "sure?".tr(),
                        leading: Icon(Icons.warning_sharp),
                        subtitle: "join-course".tr(namedArgs: {"course": preview.title}),
                        firstOption: "confirm".tr(),
                        secondOption: "cancel".tr(),
                        onFirstOption: () async {
                          http.Response response =
                              await Provider.of<CourseProvider>(context, listen: false).signup(preview.courseID);
                          if (response.statusCode == 302) {
                            //Force update the course provider to reflect the new course
                            User user = await Provider.of<UserProvider>(context, listen: false).get("self");
                            Provider.of<CourseProvider>(context, listen: false)
                                .forceUpdate(context, user.userID, <Semester>[preview.endSemester]);

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                "join-success".tr(namedArgs: {"course": preview.title}),
                                style: GoogleFonts.montserrat(),
                              ),
                            ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                "join-fail".tr(),
                                style: GoogleFonts.montserrat(),
                              ),
                            ));
                          }
                        },
                        onSecondOption: () {},
                      );
                    },
                    style: RAISED_ICON_BUTTON_STYLE(Colors.blue),
                    child: Icon(FontAwesome.sign_in),
                  ),
                  padding: EdgeInsets.only(right: 5),
                )
              : Container(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Icon(Icons.check, color: Colors.white),
                    style: RAISED_ICON_BUTTON_STYLE(Colors.green),
                  ),
                  padding: EdgeInsets.only(right: 5),
                ),
        ],
      ));
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    //TODO filter support here as well (See courseProvider 'searchFor' method)
    List<Semester> semesters =
        Provider.of<SemesterProvider>(context, listen: false).get(SemesterFilter(FilterType.ALL, null));
    Future<List<Course>> courses = Provider.of<CourseProvider>(context).get(context, this.widget._userID, semesters);

    return Scaffold(
      appBar: AppBar(
        title: Text("search".tr(), style: GoogleFonts.montserrat()),
      ),
      body: FutureBuilder(
        future: courses,
        builder: (BuildContext context, AsyncSnapshot<List<Course>> signedUpSnapshot) {
          if (signedUpSnapshot.hasData) {
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      TextField(
                        controller: this.widget._controller,
                        style: GoogleFonts.montserrat(),
                        decoration: InputDecoration(
                          hintText: "search-text".tr(),
                          hintStyle: GoogleFonts.montserrat(),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(width: 2),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(width: 2),
                          ),
                        ),
                        onSubmitted: (_) {
                          setState(() {
                            this.widget._searchTerm = this.widget._controller.text;
                          });
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            this.widget._searchTerm = this.widget._controller.text;
                          });
                        },
                        child: Icon(Icons.search),
                        style: RAISED_ICON_BUTTON_STYLE(Colors.blue),
                      ),
                    ],
                  ),
                ),
                FutureBuilder(
                  future: Provider.of<CourseProvider>(context).searchFor(context, this.widget._searchTerm),
                  builder: (BuildContext context, AsyncSnapshot<List<CoursePreview>> previewSnapshot) {
                    if (previewSnapshot.hasData) {
                      return Expanded(
                        child: ListView(
                          children: _buildSearchResults(context, previewSnapshot.data, signedUpSnapshot.data),
                        ),
                      );
                    }
                    return LinearProgressIndicator();
                  },
                ),
              ],
            );
          }
          return LinearProgressIndicator();
        },
      ),
      drawer: NavDrawer(),
    );
  }
}
