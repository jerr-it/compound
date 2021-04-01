import 'package:fludip/provider/messages/messageModel.dart';
import 'package:fludip/util/str.dart';
import 'package:flutter/material.dart';

class MessageViewer extends StatefulWidget {
  Message _message;

  MessageViewer({@required message}) : _message = message;

  @override
  _MessageViewerState createState() => _MessageViewerState();
}

class _MessageViewerState extends State<MessageViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          children: [
            Text(
              widget._message.subject,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.normal,
              ),
            ),
            Divider(),
            ListTile(
              leading: Image.network(
                widget._message.sender.avatarUrlNormal,
                width: 30,
                height: 30,
              ),
              title: Text(widget._message.sender.email),
              subtitle: Text(
                StringUtil.fromUnixTime(widget._message.mkdate * 1000, "dd.MM.yyyy HH:mm"),
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Divider(),
            Text(
              StringUtil.removeHTMLTags(widget._message.content),
            ),
          ],
        ),
      ),
    );
  }
}
