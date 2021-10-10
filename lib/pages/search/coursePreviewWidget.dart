import 'package:compound/pages/course/tabs/info.dart';
import 'package:compound/provider/course/coursePreviewModel.dart';
import 'package:compound/provider/course/courseProvider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

///Displays a course search result as a list entry
class CoursePreviewWidget extends StatelessWidget {
  CoursePreviewWidget(CoursePreview preview) : _coursePreview = preview;

  final CoursePreview _coursePreview;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ExpansionTile(
        title: Row(
          children: [
            FutureBuilder(
              future:
                  Provider.of<CourseProvider>(context, listen: false).getImage(_coursePreview.courseID, _coursePreview.type),
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
                _coursePreview.title,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.montserrat(),
              ),
            ),
          ],
        ),
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                InfoLineWidget("number".tr(), _coursePreview.number ?? ""),
                InfoLineWidget("subtitle".tr(), _coursePreview.subtitle ?? ""),
                InfoLineWidget("description".tr(), _coursePreview.description ?? ""),
                InfoLineWidget("location".tr(), _coursePreview.location ?? ""),
                InfoLineWidget("start".tr(), _coursePreview.startSemester.title ?? ""),
                InfoLineWidget("end".tr(), _coursePreview.endSemester?.title ?? "unlimited"),
              ],
            ),
          )
        ],
      ),
    );
  }
}
