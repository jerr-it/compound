import 'package:fludip/data/user.dart';
import 'package:flutter/material.dart';

class NavDrawerHeader extends StatefulWidget {
  @override
  _NavDrawerHeaderState createState() => _NavDrawerHeaderState();
}

class _NavDrawerHeaderState extends State<NavDrawerHeader> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //TODO rank?
    //TODO user profile picture instead of icon
    String formattedName = User.data["attributes"]["formatted-name"].toString();
    String username = User.data["attributes"]["username"].toString();
    String email = User.data["attributes"]["email"].toString();

    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.portrait, size: 64,),
                Column(
                  children: [
                    Text(formattedName, style: TextStyle(fontSize: 16),),
                    Text(username, style: TextStyle(fontSize: 16),)
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(email, style: TextStyle(fontWeight: FontWeight.w300),),
                Text("[Something here]", style: TextStyle(fontWeight: FontWeight.w300),)
              ],
            )
          ],
        ),
      ),
    );
  }
}