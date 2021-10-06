import 'package:fludip/navdrawer/navDrawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil", style: GoogleFonts.montserrat()),
      ),
      body: Center(
        child: Text("This is the profil page"),
      ),
      drawer: NavDrawer(),
    );
  }
}
