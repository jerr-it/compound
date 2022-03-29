import 'package:compound/pages/course/tabs/info.dart';
import 'package:compound/provider/course/coursePreviewModel.dart';
import 'package:compound/provider/course/courseProvider.dart';
import 'package:compound/provider/course/semester/semesterModel.dart';
import 'package:compound/provider/user/userModel.dart';
import 'package:compound/provider/user/userProvider.dart';
import 'package:compound/util/dialogs/confirmDialog.dart';
import 'package:compound/util/widgets/styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
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

///Displays a course search result as a list entry
class CoursePreviewWidget extends StatelessWidget {
  CoursePreviewWidget(BuildContext context, CoursePreview preview, bool isSignedUp)
      : _context = context,
        _coursePreview = preview,
        _isSignedUp = isSignedUp;

  final BuildContext _context;
  final CoursePreview _coursePreview;
  final bool _isSignedUp;

  void onJoinPressed(CoursePreview preview) {
    ConfirmDialog.display(
      _context,
      title: "sure?".tr(),
      leading: Icon(Icons.warning_sharp),
      subtitle: "join-course".tr(namedArgs: {"course": preview.title}),
      firstOptionIcon: Icon(FontAwesome.sign_in),
      firstOptionColor: Theme.of(_context).colorScheme.primary,
      secondOptionIcon: Icon(Icons.close),
      secondOptionColor: Theme.of(_context).colorScheme.primary,
      onFirstOption: () async {
        ScaffoldMessenger.of(_context).showSnackBar(SnackBar(
          content: FutureBuilder(
            future: Provider.of<CourseProvider>(_context, listen: false).signup(preview.courseID),
            builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.statusCode == 302) {
                  //Force update the course provider to reflect the new course
                  Provider.of<UserProvider>(context, listen: false).get("self").then((User user) {
                    Provider.of<CourseProvider>(context, listen: false)
                        .forceUpdate(context, user.userID, <Semester>[preview.endSemester]);
                  });
                  return Text(
                    "join-success".tr(namedArgs: {"course": preview.title}),
                  );
                }
                return Text(
                  "join-fail".tr(),
                );
              }

              if (snapshot.hasError) {
                return ErrorWidget(snapshot.error.toString());
              }

              return Row(children: [
                Container(
                  padding: EdgeInsets.all(5),
                  child: CircularProgressIndicator(),
                ),
                Text("signing-in".tr()),
              ]);
            },
          ),
        ));
      },
      onSecondOption: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _isSignedUp ? 0.5 : 1.0,
      child: ExpansionTile(
        leading: FutureBuilder(
          future: Provider.of<CourseProvider>(context, listen: false).getImage(_coursePreview.courseID, _coursePreview.type),
          builder: (BuildContext context, AsyncSnapshot<MemoryImage> snapshot) {
            if (snapshot.hasData) {
              return FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: snapshot.data,
                width: 32,
              );
            }
            if (snapshot.hasError) {
              return ErrorWidget(snapshot.error.toString());
            }
            return CircularProgressIndicator();
          },
        ),
        title: Text(
          _coursePreview.title,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          _coursePreview.startSemester.title,
          overflow: TextOverflow.ellipsis,
        ),
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              children: [
                InfoLineWidget("number".tr(), _coursePreview.number ?? ""),
                InfoLineWidget("subtitle".tr(), _coursePreview.subtitle ?? ""),
                InfoLineWidget("description".tr(), _coursePreview.description ?? ""),
                InfoLineWidget("location".tr(), _coursePreview.location ?? ""),
                InfoLineWidget("start".tr(), _coursePreview.startSemester.title ?? ""),
                InfoLineWidget("end".tr(), _coursePreview.endSemester?.title ?? "unlimited"),
                _isSignedUp
                    ? ElevatedButton(
                        onPressed: () {},
                        child: Icon(Icons.check),
                        style: raisedIconButtonStyle(context),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          onJoinPressed(_coursePreview);
                        },
                        child: Icon(Icons.login),
                        style: raisedIconButtonStyle(context),
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
