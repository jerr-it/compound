import 'package:flutter/material.dart';

import '../str.dart';

class Announcement extends StatelessWidget {
  final String _title;
  final int _timeStamp;
  final String _body;

  Announcement({@required title, @required time, @required body})
      : _title = title,
        _timeStamp = time,
        _body = body;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        leading: Icon(
          Icons.announcement,
          size: 36,
        ),
        title: Text(_title),
        subtitle: Text(
          StringUtil.fromUnixTime(_timeStamp, "dd.MM.yyyy HH:mm"),
        ),
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: Text(_body),
          ),
        ],
      ),
    );
  }
}
