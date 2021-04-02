import 'package:fludip/provider/calendar/calendarEntry.dart';
import 'package:fludip/provider/calendar/calendarProvider.dart';
import 'package:fludip/util/str.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScheduleDrawer extends StatelessWidget {
  ///Converts an int like 1430, representing clock time, to a string 14:30
  String _fromTime(int time) {
    var chars = time.toString().characters.toList();
    chars.insert(chars.length - 2, ":");
    return chars.join();
  }

  List<Widget> _buildEntryList(List<CalendarEntry> entries, DateTime today) {
    List<Widget> widgets = <Widget>[];

    widgets.add(
      DrawerHeader(
        child: Header(today),
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
      ),
    );

    entries.forEach((calendarEntry) {
      widgets.add(Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Container(
                  child: Text(
                    _fromTime(calendarEntry.start),
                    style: TextStyle(
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
                  style: TextStyle(
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
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  calendarEntry.content,
                  style: TextStyle(fontWeight: FontWeight.w500),
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
    List<CalendarEntry> entries = Provider.of<CalendarProvider>(context).getEntries()[today.day];

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: _buildEntryList(entries, today),
      ),
    );
  }
}

class Header extends StatelessWidget {
  final DateTime _today;

  Header(DateTime today) : _today = today;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            Text(
              StringUtil.fromUnixTime(_today.millisecondsSinceEpoch, "EEEE, dd.MM.yyyy"),
              style: TextStyle(fontSize: 18),
            ),
            Text(
              StringUtil.fromUnixTime(_today.millisecondsSinceEpoch, "HH:mm"),
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
