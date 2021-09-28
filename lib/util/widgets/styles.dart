import 'package:flutter/material.dart';

final Function RAISED_BUTTON_STYLE = (Color primaryColor) {
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
