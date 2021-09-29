import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoDialog {
  static void display(
    BuildContext context, {
    @required String title,
    @required String body,
  }) {
    AlertDialog dialog = AlertDialog(
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.warning_sharp),
                Text(title, style: GoogleFonts.montserrat()),
              ],
            ),
            Text(body, style: GoogleFonts.montserrat()),
            Divider(),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "understand".tr(),
                style: GoogleFonts.montserrat(),
              ),
            ),
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
