import 'package:fludip/provider/course/forumProvider.dart';
import 'package:fludip/util/commonWidgets.dart';
import 'package:fludip/util/str.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForumTopicsViewer extends StatefulWidget {
  String _courseID;
  String _categoryIDUrl;
  String _areaIDUrl;

  List<dynamic> _topicsData;

  ForumTopicsViewer({@required courseID, @required categoryIDUrl, @required areaIDUrl})
  : _courseID = courseID,
    _categoryIDUrl = categoryIDUrl,
    _areaIDUrl = areaIDUrl;

  @override
  _ForumTopicsViewerState createState() => _ForumTopicsViewerState();
}

class _ForumTopicsViewerState extends State<ForumTopicsViewer> {

  List<Widget> _buildTopicList(){
    List<Widget> widgets = <Widget>[];
    if(widget._topicsData == null){
      return widgets;
    }

    widget._topicsData.forEach((topicData) {
      print(StringUtil.removeHTMLTags(topicData["subject"]));
      widgets.add(ListTile(
        leading: Icon(Icons.forum),
        title: Text(StringUtil.removeHTMLTags(topicData["subject"])),
        subtitle: Text(StringUtil.removeHTMLTags(topicData["content"])),
        onTap: (){

        },
      ));
      widgets.add(Divider());
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    widget._topicsData = Provider.of<ForumProvider>(context).getTopicsMap(widget._courseID, widget._categoryIDUrl, widget._areaIDUrl);

    return Scaffold(
      appBar: AppBar(
        title: Text("Topics"),
      ),
      body: ListView(
        children: _buildTopicList(),
      ),
    );
  }
}
