import 'package:fludip/navdrawer/navDrawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilePage extends StatefulWidget {
  @override
  _FilePageState createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dateien", style: GoogleFonts.montserrat()),
      ),
      body: Center(
        child: Text("This is the Dateien page"),
      ),
      drawer: NavDrawer(),
    );
  }
}
