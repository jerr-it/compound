import 'dart:convert';

import 'package:fludip/net/webClient.dart';
import 'package:fludip/provider/calendar/calendarEntry.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

///Provides the users schedule
class CalendarProvider extends ChangeNotifier {
  List<List<CalendarEntry>> _calendarEntries;
  final WebClient _client = WebClient();

  bool initialized() {
    return _calendarEntries != null;
  }

  Future<List<List<CalendarEntry>>> get(String userID) {
    if (!initialized()) {
      return forceUpdate(userID);
    }
    return Future<List<List<CalendarEntry>>>.value(_calendarEntries);
  }

  Future<List<List<CalendarEntry>>> forceUpdate(String userID) async {
    _calendarEntries ??= <List<CalendarEntry>>[];

    Response res = await _client.httpGet("/user/$userID/schedule", APIType.REST);
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

    notifyListeners();
    return Future<List<List<CalendarEntry>>>.value(_calendarEntries);
  }
}
