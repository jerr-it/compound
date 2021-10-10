import 'package:compound/navdrawer/navDrawer.dart';
import 'package:compound/net/savedServers.dart';
import 'package:compound/net/server.dart';
import 'package:compound/net/webClient.dart';
import 'package:compound/pages/login/addServerPage.dart';
import 'package:compound/pages/login/credentialsPage.dart';
import 'package:compound/pages/startPage.dart';
import 'package:compound/provider/user/userProvider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// Compound - Mobile StudIP client
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

///Select and log in to a server previously added via [AddServerPage]
class ServerSelectPage extends StatefulWidget {
  final SlidableController slideController = SlidableController();

  @override
  _ServerSelectPageState createState() => _ServerSelectPageState();
}

class _ServerSelectPageState extends State<ServerSelectPage> {
  void login(BuildContext context, Server entry) async {
    var client = WebClient();
    client.server = entry;

    var storage = new FlutterSecureStorage();
    var username = await storage.read(key: "username");
    var password = await storage.read(key: "password");

    if (username == null || password == null) {
      Navigator.of(context).push(navRoute(CredentialsPage(entry.name)));
      return;
    }

    int statusCode = await client.authenticate(username, password);
    if (statusCode != 200) {
      await SavedServers().save();

      await Provider.of<UserProvider>(context, listen: false).get("self");

      if (statusCode == 401) {
        Navigator.of(context).push(navRoute(CredentialsPage(entry.name)));
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "auth-error".tr(namedArgs: {"statusCode": statusCode.toString()}),
          style: GoogleFonts.montserrat(),
        ),
      ));
      return;
    }

    Navigator.of(context).push(navRoute(StartPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image(
          height: 50,
          image: AssetImage("banner_transparent.png"),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: SavedServers().entries.isNotEmpty
            ? ListView(
                children: SavedServers().entries.map((Server entry) {
                  return Slidable(
                    controller: this.widget.slideController,
                    actionPane: SlidableStrechActionPane(),
                    actionExtentRatio: 1 / 5,
                    child: ListTile(
                      title: Text(
                        entry.name,
                        style: GoogleFonts.montserrat(),
                      ),
                      subtitle: Text(
                        entry.webAddress,
                        style: GoogleFonts.montserrat(),
                      ),
                      trailing: entry.secure
                          ? TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                    "secure-con".tr(),
                                    style: GoogleFonts.montserrat(),
                                  ),
                                ));
                              },
                              child: Icon(
                                Icons.lock,
                                color: Colors.green,
                              ),
                            )
                          : TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                    "insecure-con".tr(),
                                    style: GoogleFonts.montserrat(),
                                  ),
                                ));
                              },
                              child: Icon(
                                Icons.lock_open,
                                color: Colors.red,
                              ),
                            ),
                      onTap: () async {
                        login(context, entry);
                      },
                    ),
                    secondaryActions: [
                      IconSlideAction(
                        caption: "remove".tr(),
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                          setState(() {
                            SavedServers().entries.remove(entry);
                            SavedServers().save();
                          });
                        },
                      )
                    ],
                  );
                }).toList(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "no-servers".tr(),
                    style: GoogleFonts.montserrat(fontWeight: FontWeight.w300),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          var server = await Navigator.of(context).push(navRoute(AddServerPage()));
          if (server != null) {
            setState(() {
              SavedServers().entries.add(server);
            });
          }
        },
      ),
    );
  }
}
