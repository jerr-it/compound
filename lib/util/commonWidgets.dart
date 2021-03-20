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
}
