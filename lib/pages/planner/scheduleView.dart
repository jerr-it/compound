import 'package:easy_localization/easy_localization.dart';
import 'package:compound/navdrawer/navDrawer.dart';
import 'package:compound/provider/calendar/calendarEntry.dart';
import 'package:compound/provider/calendar/calendarProvider.dart';
import 'package:compound/util/colorMapper.dart';
import 'package:compound/util/widgets/Nothing.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// Fludip - Mobile StudIP client
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

class ScheduleViewer extends StatelessWidget {
  final String userID;

  ScheduleViewer(String userid) : userID = userid;

  ///Converts an int like 1430, representing clock time, to a string 14:30
  String _fromTime(int time) {
    var chars = time.toString().characters.toList();
    chars.insert(chars.length - 2, ":");
    return chars.join();
  }

  List<Widget> _buildEntryList(List<CalendarEntry> entries, DateTime today) {
    List<Widget> widgets = <Widget>[];

    if (entries.isEmpty) {
      widgets.add(Nothing());
    }

    entries.forEach((calendarEntry) {
      widgets.add(Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: ColorMapper.convert(calendarEntry.color),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  child: Text(
                    _fromTime(calendarEntry.start),
                    style: GoogleFonts.montserrat(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black, width: 1)),
                  ),
                ),
                Text(
                  _fromTime(calendarEntry.end),
                  style: GoogleFonts.montserrat(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  calendarEntry.title,
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  calendarEntry.content,
                  style: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
                )
              ],
            )
          ],
        ),
      ));
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    Future<List<List<CalendarEntry>>> entries = Provider.of<CalendarProvider>(context).get(userID);

    return Scaffold(
      appBar: AppBar(
        title: Text("planner".tr(), style: GoogleFonts.montserrat()),
      ),
      body: FutureBuilder(
        future: entries,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              child: ListView(
                children: _buildEntryList(snapshot.data[today.weekday - 1], today),
              ),
              onRefresh: () async {
                return Provider.of<CalendarProvider>(context, listen: false).forceUpdate(userID);
              },
            );
          } else {
            return Container(
              child: LinearProgressIndicator(),
            );
          }
        },
      ),
      drawer: NavDrawer(),
    );
  }
}
