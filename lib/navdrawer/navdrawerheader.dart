import 'package:fludip/net/webclient.dart';
import 'package:flutter/material.dart';

class NavDrawerHeader extends StatelessWidget {
  final Map<String, dynamic> _user;
  NavDrawerHeader({@required user})
  : _user = user;

  @override
  Widget build(BuildContext context) {
    if (_user == null){
      return Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Text("[Couldn't load user information"),
      );
    }

    //Save user_id for later use
    Server.userID = _user["user_id"];

    //TODO rank?
    //TODO user profile picture instead of icon
    String formattedName = _user["name"]["formatted"].toString();
    String username = _user["username"].toString();
    String email = _user["email"].toString();

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
