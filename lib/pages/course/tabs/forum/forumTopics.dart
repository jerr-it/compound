import 'package:fludip/navdrawer/navDrawer.dart';
import 'package:fludip/pages/course/tabs/forum/forumEntries.dart';
import 'package:fludip/provider/course/forumProvider.dart';
import 'package:fludip/util/commonWidgets.dart';
import 'package:fludip/util/str.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForumTopicsViewer extends StatefulWidget {
  String _pageTitle;
  String _courseID;
  String _categoryIDUrl;
  String _areaIDUrl;
  Color _courseColor;

  List<dynamic> _topicsData;

  ForumTopicsViewer({@required pageTitle,@required courseID, @required categoryIDUrl, @required areaIDUrl, @required color}) :
        _pageTitle = pageTitle,
        _courseID = courseID,
        _categoryIDUrl = categoryIDUrl,
        _areaIDUrl = areaIDUrl,
        _courseColor = color;

  @override
  _ForumTopicsViewerState createState() => _ForumTopicsViewerState();
}

class _ForumTopicsViewerState extends State<ForumTopicsViewer> {

  List<Widget> _buildTopicList(){
    List<Widget> widgets = <Widget>[];
    if(widget._topicsData == null){
      return widgets;
    }

    if(widget._topicsData.isEmpty){
      return <Widget>[CommonWidgets.nothing()];
    }

    widget._topicsData.forEach((topicData) {
      String title = StringUtil.removeHTMLTags(topicData["subject"]).replaceAll("\n", "");
      String subtitle = StringUtil.removeHTMLTags(topicData["content"]).replaceAll("\n", "");
      widgets.add(ListTile(
        leading: Icon(Icons.forum, size: 30),
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: (){
          Provider.of<ForumProvider>(context, listen: false).loadTopicEntries(
            widget._courseID,
            widget._categoryIDUrl,
            widget._areaIDUrl,
            topicData["topic_id"],
          );

          Navigator.push(context, navRoute(ForumEntriesViewer(
            pageTitle: title,
            color: widget._courseColor,
            courseID: widget._courseID,
            categoryIDUrl: widget._categoryIDUrl,
            areaIDUrl: widget._areaIDUrl,
            topicID: topicData["topic_id"],
          )));
        },
      ));
      widgets.add(Divider());
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    widget._topicsData = Provider.of<ForumProvider>(context).getTopics(widget._courseID, widget._categoryIDUrl, widget._areaIDUrl);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget._pageTitle),
        backgroundColor: widget._courseColor,
      ),
      body: RefreshIndicator(
        child: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: _buildTopicList(),
          ),
        ),
        onRefresh: () async {
          Provider.of<ForumProvider>(context,listen: false).loadAreaTopics(widget._courseID, widget._categoryIDUrl, widget._areaIDUrl);
          return Future<void>.value(null);
        },
      )
    );
  }
}
