import 'package:easy_localization/easy_localization.dart';
import 'package:fludip/navdrawer/navDrawer.dart';
import 'package:fludip/net/savedServers.dart';
import 'package:fludip/net/server.dart';
import 'package:fludip/net/webClient.dart';
import 'package:fludip/pages/login/addServerPage.dart';
import 'package:fludip/pages/login/credentialsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

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
                      onTap: () {
                        WebClient().server = entry;
                        Navigator.of(context).push(navRoute(CredentialsPage(entry.name)));
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
