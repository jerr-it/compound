import 'package:fludip/navdrawer/navDrawer.dart';
import 'package:fludip/pages/course/tabs/forum/forumTopics.dart';
import 'package:fludip/provider/course/forum/forumProvider.dart';
import 'package:fludip/util/commonWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ForumTab extends StatefulWidget {
  final String _courseID;
  Map<String, dynamic> _forumData;
  Color _courseColor;

  ForumTab({@required courseID, @required color})
      : _courseID = courseID,
        _courseColor = color;

  @override
  _ForumTabState createState() => _ForumTabState();
}

class _ForumTabState extends State<ForumTab> {
  List<Widget> _buildCategoryList() {
    List<Widget> widgets = <Widget>[];

    if (widget._forumData == null) {
      return widgets;
    }

    //1. display category name large
    //2. display subtopics of category
    Map<String, dynamic> categories;
    try {
      categories = widget._forumData["collection"];
    } catch (e) {
      //There are no forum categories (forum is entirely empty)
      return <Widget>[CommonWidgets.nothing()];
    }

    categories.forEach((categoryKey, categoryData) {
      String categoryName = categoryData["entry_name"];
      widgets.add(Text(
        categoryName,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ));

      Map<String, dynamic> areas;
      try {
        areas = categoryData["areas"]["collection"];
      } catch (e) {
        widgets.add(ListTile(
          leading: Icon(Icons.assignment_late),
          title: Text(
            "Nothing here :(",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w100),
          ),
        ));
        return;
      }

      areas.forEach((areaKey, areaData) {
        String subject = areaData["subject"];
        String content = areaData["content"];

        widgets.add(ListTile(
          leading: Icon(Icons.topic, size: 30),
          title: Text(subject),
          subtitle: Text(content),
          onTap: () {
            String course = categoryData["course"].toString().replaceFirst("/studip/api.php/course/", "");
            String category = "/studip/api.php/forum_category/" + categoryData["category_id"].toString();

            Provider.of<ForumProvider>(context, listen: false).loadAreaTopics(course, category, areaKey);

            Navigator.push(
              context,
              navRoute(
                ForumTopicsViewer(
                  pageTitle: subject,
                  courseID: course,
                  categoryIDUrl: category,
                  areaIDUrl: areaKey,
                  color: widget._courseColor,
                ),
              ),
            );
          },
        ));
      });
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    widget._forumData = Provider.of<ForumProvider>(context).getData(widget._courseID);

    return Scaffold(
      appBar: AppBar(
        title: Text("Forum"),
        backgroundColor: widget._courseColor,
      ),
      body: RefreshIndicator(
        child: Container(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            children: _buildCategoryList(),
          ),
        ),
        onRefresh: () async {
          Provider.of<ForumProvider>(context, listen: false).update(widget._courseID);
          return Future<void>.value(null);
        },
      ),
    );
  }
}
