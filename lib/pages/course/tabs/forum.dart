import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../colormapper.dart';

class ForumTab extends StatefulWidget {
  final Map<String, dynamic> _courseData;

  ForumTab({@required data})
      : _courseData = data;

  @override
  _ForumTabState createState() => _ForumTabState();
}

class _ForumTabState extends State<ForumTab> {
  List<Widget> _gatherCategories(){
    Map<String, dynamic> categories;
    try{
      categories = widget._courseData["modules"]["forum"]["collection"];
    }catch(e){
      return <Widget>[
        Container(
          padding: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Nothing here :(",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          )
        )
      ];
    }
    List<Widget> widgets = <Widget>[];

    categories.forEach((categoryKey, categoryData) {
      String name = categoryData["entry_name"];
      print(categoryData);

      widgets.add(ListTile(
        leading: Icon(Icons.forum_outlined),
        title: Text(name),
      ));

      widgets.add(Divider());
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forum: " + widget._courseData["title"]),
        backgroundColor: ColorMapper.convert(widget._courseData["group"]),
      ),
      body: Container(
        child: ListView(
          children: _gatherCategories(),
        ),
      ),
    );
  }
}
