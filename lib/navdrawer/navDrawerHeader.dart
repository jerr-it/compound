import 'package:fludip/provider/user/userModel.dart';
import 'package:fludip/provider/user/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NavDrawerHeader extends StatelessWidget {
  Widget filledHeader(User user) {
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
                      style: GoogleFonts.montserrat(fontSize: 16),
                    ),
                    Text(
                      user.userName,
                      style: GoogleFonts.montserrat(fontSize: 16),
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
                  style: GoogleFonts.montserrat(fontWeight: FontWeight.w300),
                ),
                Text(
                  user.permissions,
                  style: GoogleFonts.montserrat(fontWeight: FontWeight.w300),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget placeholderHeader() {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      child: Placeholder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<User> user = Provider.of<UserProvider>(context).get("self");

    return FutureBuilder(
      future: user,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return filledHeader(snapshot.data);
        } else {
          return placeholderHeader();
        }
      },
    );
  }
}
