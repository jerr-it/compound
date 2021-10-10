import 'package:compound/net/server.dart';
import 'package:compound/util/widgets/styles.dart';
import 'package:easy_localization/easy_localization.dart';
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

///Page to add another StudIP instances to the start screen
class AddServerPage extends StatelessWidget {
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _urlController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "add-server".tr(),
          style: GoogleFonts.montserrat(),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Text(
              "give-server-info".tr(),
              style: GoogleFonts.montserrat(),
              textAlign: TextAlign.center,
            ),
            Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "name".tr(),
                    hintStyle: GoogleFonts.montserrat(),
                    icon: Icon(
                      Icons.school,
                      color: Theme.of(context).hintColor,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 2),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 2),
                    ),
                  ),
                ),
                TextFormField(
                  controller: _urlController,
                  decoration: InputDecoration(
                    hintText: "url".tr(),
                    hintStyle: GoogleFonts.montserrat(),
                    icon: Icon(
                      Icons.link,
                      color: Theme.of(context).hintColor,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 2),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 2),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          //TODO display help
                        },
                        child: Icon(Icons.help),
                        style: raisedIconButtonStyle(context),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Server server = new Server(name: _nameController.text, webAddress: _urlController.text);
                          Navigator.pop(context, server);
                        },
                        child: Icon(Icons.check),
                        style: raisedIconButtonStyle(context),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
