import 'dart:convert';

import 'package:fludip/net/webClient.dart';
import 'package:fludip/provider/calendar/calendarEntry.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

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

  void resetCache() {
    _calendarEntries = null;
  }
}
