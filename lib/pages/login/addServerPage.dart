import 'package:easy_localization/easy_localization.dart';
import 'package:fludip/net/server.dart';
import 'package:fludip/util/widgets/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddServerPage extends StatelessWidget {
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _urlController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "add-server".tr(),
          style: GoogleFonts.montserrat(),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Text(
              "give-server-info".tr(),
              style: GoogleFonts.montserrat(),
              textAlign: TextAlign.center,
            ),
            Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "name".tr(),
                    hintStyle: GoogleFonts.montserrat(color: Colors.black26),
                    icon: Icon(
                      Icons.school,
                      color: Colors.black,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38, width: 2),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12, width: 2),
                    ),
                  ),
                ),
                TextFormField(
                  controller: _urlController,
                  decoration: InputDecoration(
                    hintText: "url".tr(),
                    hintStyle: GoogleFonts.montserrat(color: Colors.black26),
                    icon: Icon(
                      Icons.link,
                      color: Colors.black,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38, width: 2),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12, width: 2),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Row(children: [
                    ElevatedButton(
                      onPressed: () {
                        //TODO display help
                      },
                      child: Icon(Icons.help),
                      style: RAISED_ICON_BUTTON_STYLE(Colors.blue),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Server server = new Server(name: _nameController.text, webAddress: _urlController.text);
                        Navigator.pop(context, server);
                      },
                      child: Icon(Icons.check),
                      style: RAISED_ICON_BUTTON_STYLE(Colors.blue),
                    ),
                  ]),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
