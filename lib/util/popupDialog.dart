import 'package:flutter/material.dart';

class Popup {
  static void display(
    BuildContext context, {
    @required String title,
    @required String firstOption,
    Color firstOptionColor = Colors.blue,
    @required String secondOption,
    Color secondOptionColor = Colors.blue,
    @required Function onFirstOption,
    @required Function onSecondOption,
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
                    onFirstOption();
                    Navigator.of(context).pop();
                  },
                  child: Text(firstOption),
                  style: ElevatedButton.styleFrom(primary: firstOptionColor),
                ),
                ElevatedButton(
                  onPressed: () {
                    onSecondOption();
                    Navigator.of(context).pop();
                  },
                  child: Text(secondOption),
                  style: ElevatedButton.styleFrom(primary: secondOptionColor),
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
