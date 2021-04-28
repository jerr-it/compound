import 'package:fludip/navdrawer/navDrawer.dart';
import 'package:fludip/pages/course/tabs/forum/forumTopics.dart';
import 'package:fludip/provider/course/forum/categoryModel.dart';
import 'package:fludip/provider/course/forum/forumProvider.dart';
import 'package:fludip/provider/course/overview/courseModel.dart';
import 'package:fludip/util/colorMapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ForumTab extends StatelessWidget {
  final Course _course;

  ForumTab({@required course}) : _course = course;

  List<Widget> _buildCategoryList(BuildContext context, List<ForumCategory> categories) {
    List<Widget> widgets = <Widget>[];

    //1. display category name large
    //2. display subtopics of category
    for (int categoryIdx = 0; categoryIdx < categories.length; categoryIdx++) {
      widgets.add(Text(
        categories[categoryIdx].name,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ));

      if (categories[categoryIdx].areas == null) {
        return <Widget>[LinearProgressIndicator()];
      }

      for (int areaIdx = 0; areaIdx < categories[categoryIdx].areas.length; areaIdx++) {
        widgets.add(ListTile(
          leading: Icon(Icons.topic, size: 30),
          title: Text(categories[categoryIdx].areas[areaIdx].subject),
          subtitle: Text(categories[categoryIdx].areas[areaIdx].content),
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
        title: Text("Forum"),
        backgroundColor: ColorMapper.convert(_course.group),
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
