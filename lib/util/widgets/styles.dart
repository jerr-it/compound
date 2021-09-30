import 'package:flutter/material.dart';

final Function RAISED_TEXT_BUTTON_STYLE = (Color primaryColor) {
  return ElevatedButton.styleFrom(
    onPrimary: Colors.black87,
    primary: primaryColor,
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(80)),
    ),
  );
};

final Function RAISED_ICON_BUTTON_STYLE = (Color primaryColor) {
  return ElevatedButton.styleFrom(
    onPrimary: Colors.black87,
    primary: primaryColor,
    minimumSize: Size(1, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(80)),
    ),
  );
};
