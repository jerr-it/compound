import 'package:fludip/navdrawer/navDrawer.dart';
import 'package:fludip/pages/course/tabs/forum/forumEntries.dart';
import 'package:fludip/provider/course/forum/forumProvider.dart';
import 'package:fludip/provider/course/forum/topicModel.dart';
import 'package:fludip/util/commonWidgets.dart';
import 'package:fludip/util/str.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForumTopicsViewer extends StatefulWidget {
  String _pageTitle;
  String _courseID;
  int _categoryIdx;
  int _areaIdx;
  Color _courseColor;

  List<ForumTopic> _topics;

  ForumTopicsViewer({@required pageTitle, @required courseID, @required categoryIdx, @required areaIdx, @required color})
      : _pageTitle = pageTitle,
        _courseID = courseID,
        _categoryIdx = categoryIdx,
        _areaIdx = areaIdx,
        _courseColor = color;

  @override
  _ForumTopicsViewerState createState() => _ForumTopicsViewerState();
}

class _ForumTopicsViewerState extends State<ForumTopicsViewer> {
  List<Widget> _buildTopicList() {
    List<Widget> widgets = <Widget>[];
    if (widget._topics == null) {
      return widgets;
    }

    if (widget._topics.isEmpty) {
      return <Widget>[CommonWidgets.nothing()];
    }

    for (int topicIdx = 0; topicIdx < widget._topics.length; topicIdx++) {
      String title = StringUtil.removeHTMLTags(widget._topics[topicIdx].subject.replaceAll("\n", ""));
      String subtitle = StringUtil.removeHTMLTags(widget._topics[topicIdx].content.replaceAll("\n", ""));

      widgets.add(ListTile(
        leading: Icon(Icons.forum, size: 30),
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: () async {
          await Provider.of<ForumProvider>(context, listen: false).updateEntries(
            widget._courseID,
            widget._categoryIdx,
            widget._areaIdx,
            topicIdx,
          );

          Navigator.push(
            context,
            navRoute(
              ForumEntriesViewer(
                pageTitle: title,
                color: widget._courseColor,
                courseID: widget._courseID,
                categoryIdx: widget._categoryIdx,
                areaIdx: widget._areaIdx,
                topicIdx: topicIdx,
              ),
            ),
          );
        },
      ));

      widgets.add(Divider());
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    widget._topics = Provider.of<ForumProvider>(context).getTopics(widget._courseID, widget._categoryIdx, widget._areaIdx);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget._pageTitle),
        backgroundColor: widget._courseColor,
      ),
      body: RefreshIndicator(
        child: Container(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            children: _buildTopicList(),
          ),
        ),
        onRefresh: () async {
          await Provider.of<ForumProvider>(context, listen: false)
              .updateTopics(widget._courseID, widget._categoryIdx, widget._areaIdx);
          return Future<void>.value(null);
        },
      ),
    );
  }
}
