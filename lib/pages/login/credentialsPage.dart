import 'package:compound/navdrawer/navDrawer.dart';
import 'package:compound/net/savedServers.dart';
import 'package:compound/net/webClient.dart';
import 'package:compound/pages/startPage.dart';
import 'package:compound/provider/user/userProvider.dart';
import 'package:compound/util/widgets/styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

class CredentialsPage extends StatelessWidget {
  CredentialsPage(String name) : serverName = name;

  final String serverName;
  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          serverName,
          style: GoogleFonts.montserrat(),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Text(
              "give-server-credentials".tr(),
              style: GoogleFonts.montserrat(),
              textAlign: TextAlign.center,
            ),
            Column(
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: "username".tr(),
                    hintStyle: GoogleFonts.montserrat(),
                    icon: Icon(
                      Icons.person,
                      color: Theme.of(context).hintColor,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 2),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 2),
                    ),
                  ),
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "password".tr(),
                    hintStyle: GoogleFonts.montserrat(),
                    icon: Icon(
                      Icons.password,
                      color: Theme.of(context).hintColor,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 2),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 2),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    var client = WebClient();
                    int statusCode = await client.authenticate(_usernameController.text, _passwordController.text);
                    if (statusCode == 200) {
                      var storage = new FlutterSecureStorage();
                      storage.write(key: "username", value: _usernameController.text);
                      storage.write(key: "password", value: _passwordController.text);

                      await SavedServers().save();

                      await Provider.of<UserProvider>(context, listen: false).get("self");

                      Navigator.of(context).pushReplacement(navRoute(StartPage()));
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("auth-error".tr(namedArgs: {"errorCode": statusCode.toString()})),
                    ));
                  },
                  child: Icon(Icons.login),
                  style: RAISED_ICON_BUTTON_STYLE(Colors.blue),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
