import 'package:flutter/material.dart';
import 'package:fludip/navdrawer/navDrawer.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil"),
      ),
      body: Center(
        child: Text("This is the profil page"),
      ),
      drawer: NavDrawer(),
    );
  }
}
