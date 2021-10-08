import 'package:easy_localization/easy_localization.dart';
import 'package:fludip/navdrawer/navDrawer.dart';
import 'package:fludip/net/savedServers.dart';
import 'package:fludip/net/server.dart';
import 'package:fludip/net/webClient.dart';
import 'package:fludip/pages/login/addServerPage.dart';
import 'package:fludip/pages/login/credentialsPage.dart';
import 'package:fludip/pages/startPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

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

class ServerSelectPage extends StatefulWidget {
  Server server;
  final SlidableController slideController = SlidableController();

  @override
  _ServerSelectPageState createState() => _ServerSelectPageState();
}

class _ServerSelectPageState extends State<ServerSelectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "login".tr(),
          style: GoogleFonts.montserrat(),
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
                      onTap: () async {
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
