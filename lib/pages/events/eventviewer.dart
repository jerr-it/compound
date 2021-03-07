import 'package:fludip/pages/events/tabs/files.dart';
import 'package:fludip/pages/events/tabs/forum.dart';
import 'package:fludip/pages/events/tabs/members.dart';
import 'package:fludip/pages/events/tabs/news.dart';
import 'package:flutter/material.dart';

class EventViewer extends StatefulWidget {
  final Map<String,dynamic> _eventData;

  EventViewer({@required eventData})
  : _eventData = eventData;

  @override
  _EventViewerState createState() => _EventViewerState();
}

//TODO tab-view
class _EventViewerState extends State<EventViewer> {
  @override
  Widget build(BuildContext context) {
    String title = widget._eventData["title"].toString();
    String courseID = widget._eventData["course_id"];

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.announcement),),
              Tab(icon: Icon(Icons.forum),),
              Tab(icon: Icon(Icons.people),),
              Tab(icon: Icon(Icons.file_copy))
            ],
          ),
          title: Text(title),
        ),
        body: TabBarView(
          children: [
            NewsTab(courseID: courseID),
            ForumTab(courseID: courseID),
            MembersTab(courseID: courseID),
            FilesTab(courseID: courseID,)
          ],
        ),
      ),
    );
  }
}
