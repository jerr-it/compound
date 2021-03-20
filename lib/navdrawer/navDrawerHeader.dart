import 'package:fludip/provider/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //TODO rank?
    var data = Provider.of<UserProvider>(context).getData();
    String formattedName = data["name"]["formatted"].toString();
    String username = data["name"]["username"].toString();
    String email = data["email"].toString();

    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                  child: Image.network(
                    data["avatar_medium"],
                    width: 40,
                    height: 40,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      formattedName,
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      username,
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  email,
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
                Text(
                  "[Something here]",
                  style: TextStyle(fontWeight: FontWeight.w300),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
