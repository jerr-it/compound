import 'package:compound/navdrawer/navDrawer.dart';
import 'package:compound/pages/community/blubberThreadViewer.dart';
import 'package:compound/pages/course/page/gridButton.dart';
import 'package:compound/pages/course/tabs/files.dart';
import 'package:compound/pages/course/tabs/forum/forum.dart';
import 'package:compound/pages/course/tabs/info.dart';
import 'package:compound/pages/course/tabs/members.dart';
import 'package:compound/provider/blubber/blubberProvider.dart';
import 'package:compound/provider/course/courseModel.dart';
import 'package:compound/provider/course/courseProvider.dart';
import 'package:compound/provider/course/semester/semesterModel.dart';
import 'package:compound/provider/user/userModel.dart';
import 'package:compound/provider/user/userProvider.dart';
import 'package:compound/util/dialogs/confirmDialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

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

//TODO: List of options for which new content appeared, for example a new file upload

///Displays a course as a list tile widget
class CourseListTile extends StatelessWidget {
  CourseListTile(SlidableController controller, Course course)
      : _controller = controller,
        _course = course;

  final Course _course;
  final SlidableController _controller;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      controller: _controller,
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 1 / 5,
      child: Container(
        decoration: BoxDecoration(border: Border(left: BorderSide(color: _course.color, width: 7.5))),
        child: ExpansionTile(
          onExpansionChanged: (_) {
            if (_controller.activeState != null) {
              _controller.activeState.close();
            }
          },
          title: Container(
            child: Row(
              children: [
                FutureBuilder(
                  future: Provider.of<CourseProvider>(context, listen: false).getImage(_course.courseID, _course.type),
                  builder: (BuildContext context, AsyncSnapshot<MemoryImage> snapshot) {
                    if (snapshot.hasData) {
                      return FadeInImage(
                        placeholder: MemoryImage(kTransparentImage),
                        image: snapshot.data,
                        width: 32,
                      );
                    }
                    return CircularProgressIndicator();
                  },
                ),
                VerticalDivider(),
                Flexible(
                  child: Text(
                    _course.title,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(),
                  ),
                ),
              ],
            ),
          ),
          children: [
            GridView.count(
              crossAxisCount: 4,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              children: [
                GridButton(
                  icon: Icons.new_releases_sharp,
                  caption: "news".tr(),
                  color: Colors.cyan,
                  onTap: () {
                    Navigator.push(context, navRoute(InfoTab(course: _course)));
                  },
                ),
                GridButton(
                  icon: Icons.forum,
                  caption: "forum".tr(),
                  color: Colors.deepOrange,
                  onTap: () {
                    Navigator.push(
                      context,
                      navRoute(ForumTab(course: _course)),
                    );
                  },
                ),
                GridButton(
                  icon: Icons.people,
                  caption: "members".tr(),
                  color: Colors.green,
                  onTap: () {
                    Navigator.push(
                      context,
                      navRoute(MembersTab(course: _course)),
                    );
                  },
                ),
                GridButton(
                  icon: Icons.file_copy,
                  caption: "files".tr(),
                  color: Colors.blue,
                  onTap: () {
                    Navigator.push(
                      context,
                      navRoute(FilesTab(course: _course, path: <int>[])),
                    );
                  },
                ),
                GridButton(
                  icon: Icons.chat,
                  caption: "blubber".tr(),
                  color: Colors.amber,
                  onTap: () async {
                    String threadName = _course.title;

                    await Provider.of<BlubberProvider>(context, listen: false).getOverview();
                    Navigator.push(
                      context,
                      navRoute(
                        BlubberThreadViewer(
                          name: threadName,
                          course: _course,
                        ),
                      ),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
      secondaryActions: [
        IconSlideAction(
          caption: "Leave".tr(),
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            ConfirmDialog.display(
              context,
              title: "sure?".tr(),
              subtitle: "leave-course".tr(namedArgs: {"course": _course.title}),
              leading: Icon(Icons.warning_sharp),
              firstOptionIcon: Icon(Icons.check),
              firstOptionColor: Colors.red,
              secondOptionIcon: Icon(Icons.close),
              onFirstOption: () async {
                Response response = await Provider.of<CourseProvider>(context, listen: false).signout(_course.courseID);
                if (response.statusCode == 302) {
                  //Force update the course provider to reflect the course change
                  User user = await Provider.of<UserProvider>(context, listen: false).get("self");
                  Provider.of<CourseProvider>(context, listen: false)
                      .forceUpdate(context, user.userID, <Semester>[_course.endSemester]);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      "leave-success".tr(namedArgs: {"course": _course.title}),
                      style: GoogleFonts.montserrat(),
                    ),
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      "leave-fail".tr(),
                      style: GoogleFonts.montserrat(),
                    ),
                  ));
                }
              },
              onSecondOption: () {},
            );
          },
        )
      ],
    );
  }
}
