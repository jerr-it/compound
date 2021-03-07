import 'package:flutter/material.dart';

class NewsTab extends StatefulWidget {
  final String _courseID;

  NewsTab({@required courseID})
  : _courseID = courseID;

  @override
  _NewsTabState createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
