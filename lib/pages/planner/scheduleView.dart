import 'package:fludip/pages/course/colorMapper.dart';
import 'package:fludip/provider/calendar/calendarEntry.dart';
import 'package:fludip/provider/calendar/calendarProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScheduleViewer extends StatelessWidget {
  ///Converts an int like 1430, representing clock time, to a string 14:30
  String _fromTime(int time) {
    var chars = time.toString().characters.toList();
    chars.insert(chars.length - 2, ":");
    return chars.join();
  }

  List<Widget> _buildEntryList(List<CalendarEntry> entries, DateTime today) {
    List<Widget> widgets = <Widget>[];

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
    List<CalendarEntry> entries = Provider.of<CalendarProvider>(context).getEntries()[today.weekday - 1];

    return Container(
      child: ListView(
        padding: EdgeInsets.only(top: 20),
        children: _buildEntryList(entries, today),
      ),
    );
  }
}
