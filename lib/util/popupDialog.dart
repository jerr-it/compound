import 'package:flutter/material.dart';

class Popup {
  static void display(
    BuildContext context, {
    @required String title,
    @required String optionA,
    @required String optionB,
    @required Function optionAAction,
    @required Function optionBAction,
  }) {
    AlertDialog dialog = AlertDialog(
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    optionAAction();
                    Navigator.of(context).pop();
                  },
                  child: Text(optionA),
                ),
                ElevatedButton(
                  onPressed: () {
                    optionBAction();
                    Navigator.of(context).pop();
                  },
                  child: Text(optionB),
                ),
              ],
            )
          ],
        ),
      ),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }
}
