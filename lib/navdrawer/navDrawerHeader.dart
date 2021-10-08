import 'package:fludip/provider/user/userModel.dart';
import 'package:fludip/provider/user/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// Fludip - Mobile StudIP client
// Copyright (C) 2021 Jerrit Gläsker

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
