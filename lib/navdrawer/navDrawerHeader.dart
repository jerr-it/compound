import 'package:fludip/provider/user/userModel.dart';
import 'package:fludip/provider/user/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //TODO rank?
    User user = Provider.of<UserProvider>(context).getData();

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
                CircleAvatar(
                  minRadius: 30,
                  maxRadius: 30,
                  foregroundImage: NetworkImage(
                    user.avatarUrlMedium,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      user.formattedName,
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      user.userName,
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
                  user.email,
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
                Text(
                  user.permissions,
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
