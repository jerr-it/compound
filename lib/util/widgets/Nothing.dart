import 'package:easy_localization/easy_localization.dart';
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

class Nothing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 2,
      child: Text(
        "nothing_here".tr(),
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w200,
        ),
      ),
    );
  }
}
