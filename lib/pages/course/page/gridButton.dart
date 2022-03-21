//Convenience class to be used in grid view below
import 'package:flutter/material.dart';

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

///Rectangular colored button with caption and icon.
///Used for course tabs.
class GridButton extends StatelessWidget {
  final IconData _icon;
  final String _caption;
  final Color _color;
  final bool _new;
  final Function _onTap;

  GridButton({@required icon, @required caption, @required color, @required onTap, @required hasNew})
      : _icon = icon,
        _caption = caption,
        _color = color,
        _onTap = onTap,
        _new = hasNew;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _color,
      child: InkWell(
        child: Stack(children: [
          Visibility(
            visible: _new,
            child: Icon(
              Icons.notifications,
              color: Theme.of(context).textTheme.bodyText1.color,
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                  tag: _caption,
                  child: Icon(
                    _icon,
                    color: Theme.of(context).textTheme.bodyText1.color,
                  ),
                ),
                Text(
                  _caption,
                ),
              ],
            ),
          ),
        ]),
        onTap: _onTap,
      ),
    );
  }
}
