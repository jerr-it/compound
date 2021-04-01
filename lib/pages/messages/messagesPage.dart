import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import 'package:fludip/pages/messages/messageViewer.dart';
import 'package:fludip/provider/messages/messageModel.dart';
import 'package:fludip/provider/messages/messageProvider.dart';
import 'package:fludip/util/popupDialog.dart';
import 'package:fludip/util/str.dart';
import 'package:fludip/navdrawer/navDrawer.dart';

class MessagesPage extends StatefulWidget {
  List<Message> _messages;
  final SlidableController slideController = SlidableController();

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  List<Widget> _buildMessageList() {
    List<Widget> widgets = <Widget>[];
    if (widget._messages == null) {
      return widgets;
    }

    widget._messages.forEach((message) {
      widgets.add(Slidable(
        controller: widget.slideController,
        actionPane: SlidableStrechActionPane(),
        actionExtentRatio: 1 / 5,
        child: ListTile(
          leading: Icon(Icons.mail, size: 30),
          title: Text(
            message.subject,
            style: TextStyle(fontWeight: message.read ? FontWeight.normal : FontWeight.bold),
          ),
          subtitle: Text(
            message.sender.formattedName,
            style: TextStyle(fontWeight: message.read ? FontWeight.normal : FontWeight.bold),
          ),
          trailing: Text(
            StringUtil.fromUnixTime(message.mkdate * 1000, "dd.MM.yyyy HH:mm"),
            style: TextStyle(
              fontWeight: FontWeight.w300,
            ),
          ),
          onTap: () {
            if (!message.read) {
              //TODO mark as read
              /*var client = WebClient();
              client.markRead(messageData["message_id"]);
              setState(() {
                widget._data[messageIdUrl]["unread"] = false;
              });*/
            }

            Navigator.push(context, navRoute(MessageViewer(message: message)));
          },
        ),
        secondaryActions: [
          IconSlideAction(
            caption: "Delete",
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              Popup.display(
                context,
                title: "Are you sure?",
                optionA: "Confirm",
                optionB: "Cancel",
                optionAAction: () {
                  //TODO delete message action
                  /*var client = WebClient();
                  client.deleteMsg(messageData["message_id"]);
                  setState(() {
                    widget._data.remove(messageIdUrl);
                  });*/
                },
                optionBAction: () {},
              );
            },
          )
        ],
      ));

      widgets.add(Divider(
        height: 5,
      ));
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    widget._messages = Provider.of<MessageProvider>(context).get();

    return Scaffold(
      appBar: AppBar(
        title: Text("Nachrichten"),
      ),
      body: RefreshIndicator(
        child: ListView(
          children: _buildMessageList(),
        ),
        onRefresh: () async {
          await Provider.of<MessageProvider>(context, listen: false).update();
        },
      ),
      drawer: NavDrawer(),
    );
  }
}
