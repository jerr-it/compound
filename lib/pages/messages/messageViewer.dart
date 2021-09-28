import 'package:fludip/provider/messages/messageModel.dart';
import 'package:fludip/util/str.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageViewer extends StatelessWidget {
  final Message _message;

  MessageViewer({@required message}) : _message = message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          children: [
            ListTile(
              leading: Image.network(
                _message.sender.avatarUrlNormal,
                width: 30,
                height: 30,
              ),
              title: Text(_message.sender.email, style: GoogleFonts.montserrat()),
              subtitle: Text(
                StringUtil.fromUnixTime(_message.mkdate * 1000, "dd.MM.yyyy HH:mm"),
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Divider(),
            Text(
              _message.subject,
              style: GoogleFonts.montserrat(
                fontSize: 28,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              StringUtil.removeHTMLTags(_message.content),
              style: GoogleFonts.montserrat(),
            ),
          ],
        ),
      ),
    );
  }
}
