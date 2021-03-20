import 'package:flutter/material.dart';

class LoadingIndicator {
  static void show(BuildContext context, String text) {
    AlertDialog dialog = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Text(text),
          )
        ],
      ),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }

  static void dismiss(BuildContext context) {
    Navigator.of(context).pop();
  }
}
