import 'dart:convert';

import 'package:fludip/net/webClient.dart';
import 'package:fludip/provider/calendar/calendarEntry.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

///Provides the users schedule
class CalendarProvider extends ChangeNotifier {
  List<List<CalendarEntry>> _calendarEntries;
  final WebClient _client = WebClient();
  String _userID;

  void setUserID(String userID) {
    _userID = userID;
  }

  bool initialized() {
    return _calendarEntries != null;
  }

  Future<void> fetchCalendar() async {
    _calendarEntries ??= <List<CalendarEntry>>[];

    Response res = await _client.httpGet("/user/$_userID/schedule");
    Map<String, dynamic> decoded = jsonDecode(res.body);

    decoded.forEach((day, entryMap) {
      List<CalendarEntry> entries = <CalendarEntry>[];
      try {
        entryMap.forEach((key, data) {
          entries.add(CalendarEntry.fromMap(data));
        });

        entries.sort((a, b) {
          return a.start - b.start;
        });

        _calendarEntries.add(entries);
      } catch (e) {
        _calendarEntries.add(<CalendarEntry>[]);
      }
    });
  }

  List<List<CalendarEntry>> getEntries() {
    return _calendarEntries;
  }
}
