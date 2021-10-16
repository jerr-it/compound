import 'package:compound/navdrawer/navDrawer.dart';
import 'package:compound/provider/calendar/calendarEntry.dart';
import 'package:compound/provider/calendar/calendarProvider.dart';
import 'package:compound/util/colorMapper.dart';
import 'package:compound/util/widgets/Nothing.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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

///Display the users schedule
class ScheduleViewer extends StatelessWidget {
  final String userID;

  ScheduleViewer(String userid) : userID = userid;

  ///Converts an int like 1430, representing clock time, to a string 14:30
  String _fromTime(int time) {
    var chars = time.toString().characters.toList();
    chars.insert(chars.length - 2, ":");
    return chars.join();
  }

  List<Widget> _buildEntryList(BuildContext context, List<CalendarEntry> entries, DateTime today) {
    List<Widget> widgets = <Widget>[];

    if (entries.isEmpty) {
      widgets.add(Nothing());
    }

    entries.forEach((calendarEntry) {
      widgets.add(Container(
        padding: EdgeInsets.only(left: 10, top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 5,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border(right: BorderSide(color: ColorMapper.convert(calendarEntry.color), width: 5))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _fromTime(calendarEntry.start),
                    style: GoogleFonts.montserrat(fontSize: 24),
                  ),
                  Text(
                    _fromTime(calendarEntry.end),
                    style: GoogleFonts.montserrat(fontSize: 18),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    calendarEntry.title,
                    style: GoogleFonts.montserrat(fontSize: 24),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    calendarEntry.content,
                    style: GoogleFonts.montserrat(fontSize: 14),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
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
                children: _buildEntryList(context, snapshot.data[today.weekday - 1], today),
              ),
              onRefresh: () async {
                return await Provider.of<CalendarProvider>(context, listen: false).forceUpdate(userID);
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
