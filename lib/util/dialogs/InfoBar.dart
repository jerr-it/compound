import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showInfo(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      content,
      style: GoogleFonts.montserrat(),
    ),
  ));
}
