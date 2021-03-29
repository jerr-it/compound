import 'package:fludip/provider/course/forum/forumProvider.dart';
import 'package:fludip/util/commonWidgets.dart';
import 'package:fludip/util/str.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForumEntriesViewer extends StatefulWidget {
  String _pageTitle;
  Color _courseColor;

  String _courseID;
  String _categoryIDUrl;
  String _areaIDUrl;
  String _topicID;

  List<dynamic> _entriesData;

  ForumEntriesViewer(
      {@required pageTitle,
      @required courseID,
      @required categoryIDUrl,
      @required areaIDUrl,
      @required color,
      @required topicID})
      : _pageTitle = pageTitle,
        _courseID = courseID,
        _categoryIDUrl = categoryIDUrl,
        _areaIDUrl = areaIDUrl,
        _courseColor = color,
        _topicID = topicID;

  @override
  _ForumEntriesViewerState createState() => _ForumEntriesViewerState();
}

///TODO show user and time stamp
class _ForumEntriesViewerState extends State<ForumEntriesViewer> {
  List<Widget> _buildEntryList() {
    List<Widget> widgets = <Widget>[];
    if (widget._entriesData == null) {
      return widgets;
    }

    if (widget._entriesData.isEmpty) {
      return <Widget>[CommonWidgets.nothing()];
    }

    widget._entriesData.forEach((entryData) {
      widgets.add(ListTile(
        leading: Icon(Icons.person, size: 30),
        title: Text(StringUtil.removeHTMLTags(entryData["content"]).replaceAll("\n", "")),
      ));
      widgets.add(Divider());
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    widget._entriesData = Provider.of<ForumProvider>(context).getTopicEntries(
      widget._courseID,
      widget._categoryIDUrl,
      widget._areaIDUrl,
      widget._topicID,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget._pageTitle),
        backgroundColor: widget._courseColor,
      ),
      body: RefreshIndicator(
        child: Container(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            children: _buildEntryList(),
          ),
        ),
        onRefresh: () async {
          Provider.of<ForumProvider>(context, listen: false)
              .loadTopicEntries(widget._courseID, widget._categoryIDUrl, widget._areaIDUrl, widget._topicID);
          return Future<void>.value(null);
        },
      ),
    );
  }
}
