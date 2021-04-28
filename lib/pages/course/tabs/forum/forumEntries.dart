import 'package:fludip/provider/course/forum/entryModel.dart';
import 'package:fludip/provider/course/forum/forumProvider.dart';
import 'package:fludip/provider/course/overview/courseModel.dart';
import 'package:fludip/util/colorMapper.dart';
import 'package:fludip/util/str.dart';
import 'package:fludip/util/widgets/Nothing.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///TODO show user and time stamp
class ForumEntriesViewer extends StatelessWidget {
  final String _pageTitle;
  final Course _course;

  final int _categoryIdx;
  final int _areaIdx;
  final int _topicIdx;

  ForumEntriesViewer({@required pageTitle, @required course, @required categoryIdx, @required areaIdx, @required topicIdx})
      : _pageTitle = pageTitle,
        _course = course,
        _categoryIdx = categoryIdx,
        _areaIdx = areaIdx,
        _topicIdx = topicIdx;

  List<Widget> _buildEntryList(List<ForumEntry> entries) {
    List<Widget> widgets = <Widget>[];
    if (entries.isEmpty) {
      return <Widget>[Nothing()];
    }

    entries.forEach((entry) {
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
    Future<List<ForumEntry>> entries = Provider.of<ForumProvider>(context).getEntries(
      _course.courseID,
      _categoryIdx,
      _areaIdx,
      _topicIdx,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitle),
        backgroundColor: ColorMapper.convert(_course.group),
      ),
      body: FutureBuilder(
        future: entries,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              child: Container(
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  children: _buildEntryList(snapshot.data),
                ),
              ),
              onRefresh: () async {
                return Provider.of<ForumProvider>(context, listen: false)
                    .forceUpdateEntries(_course.courseID, _categoryIdx, _areaIdx, _topicIdx);
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
