import 'package:fludip/provider/course/forum/entryModel.dart';
import 'package:fludip/provider/course/forum/forumProvider.dart';
import 'package:fludip/util/commonWidgets.dart';
import 'package:fludip/util/str.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForumEntriesViewer extends StatefulWidget {
  String _pageTitle;
  Color _courseColor;

  String _courseID;
  int _categoryIdx;
  int _areaIdx;
  int _topicIdx;

  List<ForumEntry> _entries;

  ForumEntriesViewer(
      {@required pageTitle,
      @required courseID,
      @required categoryIdx,
      @required areaIdx,
      @required color,
      @required topicIdx})
      : _pageTitle = pageTitle,
        _courseID = courseID,
        _categoryIdx = categoryIdx,
        _areaIdx = areaIdx,
        _courseColor = color,
        _topicIdx = topicIdx;

  @override
  _ForumEntriesViewerState createState() => _ForumEntriesViewerState();
}

///TODO show user and time stamp
class _ForumEntriesViewerState extends State<ForumEntriesViewer> {
  List<Widget> _buildEntryList() {
    List<Widget> widgets = <Widget>[];
    if (widget._entries == null) {
      return widgets;
    }

    if (widget._entries.isEmpty) {
      return <Widget>[CommonWidgets.nothing()];
    }

    widget._entries.forEach((entry) {
      widgets.add(ListTile(
        leading: Icon(Icons.person, size: 30),
        title: Text(StringUtil.removeHTMLTags(entry.content.replaceAll("\n", ""))),
      ));
      widgets.add(Divider());
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    widget._entries = Provider.of<ForumProvider>(context).getEntries(
      widget._courseID,
      widget._categoryIdx,
      widget._areaIdx,
      widget._topicIdx,
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
              .updateEntries(widget._courseID, widget._categoryIdx, widget._areaIdx, widget._topicIdx);
          return Future<void>.value(null);
        },
      ),
    );
  }
}
