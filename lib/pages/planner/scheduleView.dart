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

const Weekdays = <String>["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"];

class ScheduleViewer extends StatelessWidget {
  ScheduleViewer(String userid) : userID = userid;
  final String userID;

  ///Converts an int like 1430, representing clock time, to a string 14:30
  String _fromTime(int time) {
    var chars = time.toString().characters.toList();
    chars.insert(chars.length - 2, ":");
    return chars.join();
  }

  List<Widget> _buildEntryList(BuildContext context, List<CalendarEntry> entries) {
    List<Widget> widgets = <Widget>[];

    if (entries.isEmpty) {
      widgets.add(Nothing());
    }

    entries.forEach((calendarEntry) {
      widgets.add(Container(
        padding: EdgeInsets.only(top: 5),
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
            Expanded(
              child: Container(
                padding: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      calendarEntry.title,
                      style: GoogleFonts.montserrat(fontSize: 24),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      calendarEntry.content,
                      style: GoogleFonts.montserrat(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ));
    });

    return widgets;
  }

  List<Widget> _buildTabHeads() {
    List<Widget> widgets = <Widget>[];

    Weekdays.forEach((String day) {
      widgets.add(Tab(
        text: day.tr(),
      ));
    });

    return widgets;
  }

  List<Widget> _buildTabBodies(BuildContext context, List<List<CalendarEntry>> entries) {
    List<Widget> widgets = <Widget>[];

    entries.forEach((List<CalendarEntry> entrySet) {
      Widget tabBody = Container(
        padding: EdgeInsets.all(5),
        child: ListView(
          children: _buildEntryList(context, entrySet),
        ),
      );

      widgets.add(tabBody);
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    Future<List<List<CalendarEntry>>> entries = Provider.of<CalendarProvider>(context).get(userID);

    return DefaultTabController(
      length: 7,
      initialIndex: DateTime.now().weekday - 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text("planner".tr(), style: GoogleFonts.montserrat()),
          bottom: TabBar(
            tabs: _buildTabHeads(),
          ),
        ),
        body: FutureBuilder(
          future: entries,
          builder: (BuildContext context, AsyncSnapshot<List<List<CalendarEntry>>> snapshot) {
            if (snapshot.hasData) {
              return TabBarView(
                children: _buildTabBodies(context, snapshot.data.reversed.toList()),
              );
            } else {
              return LinearProgressIndicator();
            }
          },
        ),
        drawer: NavDrawer(),
      ),
    );
  }
}
