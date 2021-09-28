import 'package:fludip/util/widgets/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Popup {
  static void display(
    BuildContext context, {
    @required String title,
    Widget leading,
    String subtitle,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                leading,
                Text(
                  title,
                  style: GoogleFonts.montserrat(fontSize: 22),
                ),
              ],
            ),
            Text(subtitle, style: GoogleFonts.montserrat(fontSize: 16)),
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
                  style: RAISED_BUTTON_STYLE(Colors.red),
                ),
                ElevatedButton(
                  onPressed: () {
                    onSecondOption();
                    Navigator.of(context).pop();
                  },
                  child: Text(secondOption),
                  style: RAISED_BUTTON_STYLE(Colors.blue),
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
