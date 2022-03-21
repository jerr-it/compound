import 'package:flutter/material.dart';

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

///Displays an announcement
class Announcement extends StatelessWidget {
  final String _title;
  final int _timeStamp;
  final Widget _body;
  final bool _isNew;
  final Function(bool) _onExpansionChanged;

  Announcement({@required title, @required time, @required body, @required onExpansionChanged, isNew = false})
      : _title = title,
        _timeStamp = time,
        _body = body,
        _isNew = isNew,
        _onExpansionChanged = onExpansionChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        onExpansionChanged: _onExpansionChanged,
        leading: Icon(
          Icons.announcement,
          size: 36,
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                _title.trim(),
              ),
            ),
            Visibility(
              child: Icon(Icons.notifications),
              visible: _isNew,
            )
          ],
        ),
        subtitle: Text(
          StringUtil.fromUnixTime(_timeStamp, "dd.MM.yyyy HH:mm"),
        ),
        children: [
          Container(padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10), child: _body),
        ],
      ),
    );
  }
}
