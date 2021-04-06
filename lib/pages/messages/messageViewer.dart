import 'package:fludip/provider/messages/messageModel.dart';
import 'package:fludip/util/str.dart';
import 'package:flutter/material.dart';

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
              title: Text(_message.sender.email),
              subtitle: Text(
                StringUtil.fromUnixTime(_message.mkdate * 1000, "dd.MM.yyyy HH:mm"),
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Divider(),
            Text(
              _message.subject,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              StringUtil.removeHTMLTags(_message.content),
            ),
          ],
        ),
      ),
    );
  }
}
