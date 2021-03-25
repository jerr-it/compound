import 'package:fludip/util/str.dart';
import 'package:flutter/material.dart';

class MessageViewer extends StatefulWidget {
  Map<String, dynamic> _messageData;

  MessageViewer({@required messageData}) : _messageData = messageData;

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
              widget._messageData["subject"],
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.normal,
              ),
            ),
            Divider(),
            ListTile(
              leading: Image.network(
                widget._messageData["sender"]["avatar_normal"],
                width: 30,
                height: 30,
              ),
              title: Text(widget._messageData["sender"]["email"]),
              subtitle: Text(
                StringUtil.fromUnixTime(int.parse(widget._messageData["mkdate"]) * 1000, "dd.MM.yyyy HH:mm"),
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Divider(),
            Text(
              StringUtil.removeHTMLTags(widget._messageData["message"]),
            ),
          ],
        ),
      ),
    );
  }
}
