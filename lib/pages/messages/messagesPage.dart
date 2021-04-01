import 'package:fludip/util/commonWidgets.dart';
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
      return <Widget>[CommonWidgets.nothing()];
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
              Provider.of<MessageProvider>(context, listen: false).markMessageRead(message.id);
              setState(() {
                message.read = true;
              });
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
                  Provider.of<MessageProvider>(context, listen: false).deleteMessage(message.id);
                  setState(() {
                    widget._messages.remove(message);
                  });
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
