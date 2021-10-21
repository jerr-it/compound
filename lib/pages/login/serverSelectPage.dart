import 'dart:io';

import 'package:compound/navdrawer/navDrawer.dart';
import 'package:compound/net/server.dart';
import 'package:compound/net/webClient.dart';
import 'package:compound/pages/startPage.dart';
import 'package:compound/util/dialogs/InfoBar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

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

    int statusCode = -1;
    try {
      statusCode = await client.authenticate();
    } on HttpException catch (e) {
      showInfo(context, "http-exception".tr(namedArgs: {"error-str": e.toString()}));
      return;
    } on SocketException catch (e) {
      showInfo(context, "socket-exception".tr(namedArgs: {"error-str": e.toString()}));
      return;
    } on FormatException catch (e) {
      showInfo(context, "format-exception".tr(namedArgs: {"error-str": e.toString()}));
      return;
    }

    if (statusCode != 200) {
      showInfo(context, "auth-error".tr(namedArgs: {"statusCode": statusCode.toString()}));
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
        child: ListView(
          children: Server.instances.map((Server entry) {
            return ListTile(
              title: Text(
                entry.name,
                style: GoogleFonts.montserrat(),
              ),
              subtitle: Text(
                entry.webAddress,
                style: GoogleFonts.montserrat(),
              ),
              onTap: () async {
                login(context, entry);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
