import 'package:fludip/provider/course/forumProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ForumTab extends StatefulWidget {
  final String _courseID;
  Map<String, dynamic> _forumData;

  ForumTab({@required courseID})
      : _courseID = courseID;

  @override
  _ForumTabState createState() => _ForumTabState();
}

class _ForumTabState extends State<ForumTab> {
  List<Widget> _gatherCategories(){
    List<Widget> widgets = <Widget>[];

    if(widget._forumData == null){
      return widgets;
    }

    //1. display category name large
    //2. display subtopics of category
    //TODO 3. make tap on subtopics display its entries
    Map<String, dynamic> categories = widget._forumData["collection"];
    categories.forEach((categoryKey, categoryData) {
      String categoryName = categoryData["entry_name"];
      widgets.add(Text(
        categoryName,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ));

      Map<String,dynamic> areas = categoryData["areas"]["collection"];
      areas.forEach((areaKey, areaData) {
        String subject = areaData["subject"];
        String content = areaData["content"];

        widgets.add(ListTile(
          leading: Icon(Icons.topic),
          title: Text(subject),
          subtitle: Text(content),
          onTap: (){
            //TODO show entries
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
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: _gatherCategories(),
        ),
      ),
    );
  }
}
