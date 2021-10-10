import 'package:compound/navdrawer/navDrawer.dart';
import 'package:compound/pages/course/tabs/forum/forumTopics.dart';
import 'package:compound/provider/course/courseModel.dart';
import 'package:compound/provider/course/forum/categoryModel.dart';
import 'package:compound/provider/course/forum/forumProvider.dart';
import 'package:compound/util/widgets/Nothing.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
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

///Displays forum categories and areas of a given course
class ForumTab extends StatelessWidget {
  final Course _course;

  ForumTab({@required course}) : _course = course;

  List<Widget> _buildCategoryList(BuildContext context, List<ForumCategory> categories) {
    List<Widget> widgets = <Widget>[];

    if (categories.isEmpty) {
      return <Widget>[Nothing()];
    }

    //1. display category name large
    //2. display subtopics of category
    for (int categoryIdx = 0; categoryIdx < categories.length; categoryIdx++) {
      widgets.add(Text(
        categories[categoryIdx].name,
        style: GoogleFonts.montserrat(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ));

      if (categories[categoryIdx].areas == null) {
        return <Widget>[Nothing()];
      }

      for (int areaIdx = 0; areaIdx < categories[categoryIdx].areas.length; areaIdx++) {
        widgets.add(ListTile(
          leading: Icon(Icons.topic, size: 30),
          title: Text(categories[categoryIdx].areas[areaIdx].subject, style: GoogleFonts.montserrat()),
          subtitle: Text(categories[categoryIdx].areas[areaIdx].content, style: GoogleFonts.montserrat()),
          onTap: () async {
            Navigator.push(
              context,
              navRoute(
                ForumTopicsViewer(
                  title: categories[categoryIdx].areas[areaIdx].subject,
                  course: _course,
                  categoryIdx: categoryIdx,
                  areaIdx: areaIdx,
                ),
              ),
            );
          },
        ));
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    Future<List<ForumCategory>> categories = Provider.of<ForumProvider>(context).getCategories(_course.courseID);

    return Scaffold(
      appBar: AppBar(
        title: Text("forum".tr(), style: GoogleFonts.montserrat()),
        backgroundColor: _course.color,
      ),
      body: FutureBuilder(
        future: categories,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              child: Container(
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  children: _buildCategoryList(context, snapshot.data),
                ),
              ),
              onRefresh: () async {
                return Provider.of<ForumProvider>(context, listen: false).forceUpdateCategories(_course.courseID);
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
