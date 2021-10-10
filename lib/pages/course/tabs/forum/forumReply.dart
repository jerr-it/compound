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

///Screen used to write a reply in a forum
class ForumReplyScreen extends StatelessWidget {
  const ForumReplyScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, null);
          },
        ),
        title: Text("reply".tr(), style: GoogleFonts.montserrat()),
      ),
      body: SizedBox(
        width: double.maxFinite,
        child: Container(
          child: Column(
            children: [
              TextField(
                maxLines: null,
                controller: controller,
                style: GoogleFonts.montserrat(),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send),
        onPressed: () {
          Navigator.pop(context, controller.text);
        },
      ),
    );
  }
}
