import 'package:fludip/util/str.dart';
import 'package:flutter/material.dart';

///Collection of commonly used pages
class CommonWidgets {
  static Widget nothing() {
    return Center(
      child: Container(
        child: Text(
          "Nothing here :(",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  static Widget announcement(String title, int timeStamp, String body) {
    return Card(
      child: ExpansionTile(
        leading: Icon(
          Icons.announcement,
          size: 36,
        ),
        title: Text(title),
        subtitle: Text(
          StringUtil.fromUnixTime(timeStamp, "dd.MM.yyyy HH:mm"),
        ),
        children: [
          Text(body),
        ],
      ),
    );
  }
}
