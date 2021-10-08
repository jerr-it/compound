import 'package:easy_localization/easy_localization.dart';
import 'package:fludip/navdrawer/navDrawer.dart';
import 'package:fludip/pages/messages/messageViewer.dart';
import 'package:fludip/provider/messages/messageModel.dart';
import 'package:fludip/provider/messages/messageProvider.dart';
import 'package:fludip/util/dialogs/confirmDialog.dart';
import 'package:fludip/util/str.dart';
import 'package:fludip/util/widgets/Nothing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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

class MessagesPage extends StatefulWidget {
  List<Message> _messages;
  final SlidableController slideController = SlidableController();
  final String userID;

  MessagesPage(String userid) : userID = userid;

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  List<Widget> _buildMessageList() {
    List<Widget> widgets = <Widget>[];
    if (widget._messages == null) {
      return <Widget>[Nothing()];
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
            style: GoogleFonts.montserrat(fontWeight: message.read ? FontWeight.normal : FontWeight.bold),
          ),
          subtitle: Text(
            message.sender.formattedName,
            style: GoogleFonts.montserrat(fontWeight: message.read ? FontWeight.normal : FontWeight.bold),
          ),
          trailing: Text(
            StringUtil.fromUnixTime(message.mkdate * 1000, "dd.MM.yyyy HH:mm"),
            style: GoogleFonts.montserrat(
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
            caption: "delete".tr(),
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              ConfirmDialog.display(
                context,
                title: "sure?".tr(),
                subtitle: "permanent".tr(),
                leading: Icon(Icons.warning_sharp),
                firstOption: "confirm".tr(),
                firstOptionColor: Colors.red,
                onFirstOption: () {
                  Provider.of<MessageProvider>(context, listen: false).deleteMessage(message.id);
                  setState(() {
                    widget._messages.remove(message);
                  });
                },
                secondOption: "cancel".tr(),
                onSecondOption: () {},
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
    Future<List<Message>> messages = Provider.of<MessageProvider>(context).get(widget.userID);

    return Scaffold(
      appBar: AppBar(
        title: Text("messages".tr(), style: GoogleFonts.montserrat()),
      ),
      body: FutureBuilder(
        future: messages,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            widget._messages = snapshot.data;
            return RefreshIndicator(
              child: ListView(
                children: _buildMessageList(),
              ),
              onRefresh: () async {
                return Provider.of<MessageProvider>(context, listen: false).forceUpdate(widget.userID);
              },
            );
          } else {
            return Container(
              child: LinearProgressIndicator(),
            );
          }
        },
      ),
      drawer: NavDrawer(),
    );
  }
}
