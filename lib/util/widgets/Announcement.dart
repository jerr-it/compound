import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        title: Text(
          _title.trim(),
          style: GoogleFonts.montserrat(),
        ),
        subtitle: Text(
          StringUtil.fromUnixTime(_timeStamp, "dd.MM.yyyy HH:mm"),
          style: GoogleFonts.montserrat(),
        ),
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: Text(
              _body.trim(),
              style: GoogleFonts.montserrat(),
            ),
          ),
        ],
      ),
    );
  }
}
