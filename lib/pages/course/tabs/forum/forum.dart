import 'package:fludip/navdrawer/navDrawer.dart';
import 'package:fludip/pages/course/tabs/forum/forumTopics.dart';
import 'package:fludip/provider/course/forum/categoryModel.dart';
import 'package:fludip/provider/course/forum/forumProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ForumTab extends StatefulWidget {
  final String _courseID;
  List<ForumCategory> _categories;
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

    if (widget._categories == null) {
      return <Widget>[LinearProgressIndicator()];
    }

    //1. display category name large
    //2. display subtopics of category
    for (int categoryIdx = 0; categoryIdx < widget._categories.length; categoryIdx++) {
      widgets.add(Text(
        widget._categories[categoryIdx].name,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ));

      if (widget._categories[categoryIdx].areas == null) {
        return <Widget>[LinearProgressIndicator()];
      }

      for (int areaIdx = 0; areaIdx < widget._categories[categoryIdx].areas.length; areaIdx++) {
        widgets.add(ListTile(
          leading: Icon(Icons.topic, size: 30),
          title: Text(widget._categories[categoryIdx].areas[areaIdx].subject),
          subtitle: Text(widget._categories[categoryIdx].areas[areaIdx].content),
          onTap: () async {
            await Provider.of<ForumProvider>(context, listen: false).updateTopics(widget._courseID, categoryIdx, areaIdx);

            Navigator.push(
              context,
              navRoute(
                ForumTopicsViewer(
                  pageTitle: widget._categories[categoryIdx].areas[areaIdx].subject,
                  courseID: widget._courseID,
                  categoryIdx: categoryIdx,
                  areaIdx: areaIdx,
                  color: widget._courseColor,
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
    widget._categories = Provider.of<ForumProvider>(context).getCategories(widget._courseID);

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
          await Provider.of<ForumProvider>(context, listen: false).updateCategories(widget._courseID);
          return Future<void>.value(null);
        },
      ),
    );
  }
}
