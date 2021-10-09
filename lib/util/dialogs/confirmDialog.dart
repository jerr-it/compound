import 'package:compound/util/widgets/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

class ConfirmDialog {
  static void display(
    BuildContext context, {
    @required String title,
    Widget leading = const Text(""),
    String subtitle = "",
    @required Icon firstOptionIcon,
    Color firstOptionColor = Colors.blue,
    @required Icon secondOptionIcon,
    Color secondOptionColor = Colors.blue,
    @required Function onFirstOption,
    @required Function onSecondOption,
  }) {
    AlertDialog dialog = AlertDialog(
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                leading,
                Text(
                  title,
                  style: GoogleFonts.montserrat(fontSize: 22),
                ),
              ],
            ),
            Text(subtitle, style: GoogleFonts.montserrat(fontSize: 16)),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    onFirstOption();
                    Navigator.of(context).pop();
                  },
                  child: firstOptionIcon,
                  style: raisedIconButtonStyle(context, color: firstOptionColor),
                ),
                ElevatedButton(
                  onPressed: () {
                    onSecondOption();
                    Navigator.of(context).pop();
                  },
                  child: secondOptionIcon,
                  style: raisedIconButtonStyle(context, color: secondOptionColor),
                ),
              ],
            )
          ],
        ),
      ),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }
}
