import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../str.dart';

// Compound - Mobile StudIP client
// Copyright (C) 2021 Jerrit Gläsker

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
