import 'package:compound/navdrawer/navDrawer.dart';
import 'package:compound/pages/messages/messageViewer.dart';
import 'package:compound/provider/messages/messageModel.dart';
import 'package:compound/provider/messages/messageProvider.dart';
import 'package:compound/util/dialogs/confirmDialog.dart';
import 'package:compound/util/str.dart';
import 'package:compound/util/widgets/Nothing.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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

///Displays the users inbox
class MessagesPage extends StatefulWidget {
  final SlidableController slideController = SlidableController();
  final String userID;

  MessagesPage(String userid) : userID = userid;

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  List<Message> _messages;

  List<Widget> _buildMessageList() {
    List<Widget> widgets = <Widget>[];
    if (_messages == null) {
      return <Widget>[Nothing()];
    }

    _messages.forEach((message) {
      widgets.add(Slidable(
        controller: widget.slideController,
        actionPane: SlidableStrechActionPane(),
        actionExtentRatio: 1 / 5,
        child: ListTile(
          leading: Icon(Icons.mail, size: 30, color: Theme.of(context).hintColor),
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
                firstOptionIcon: Icon(Icons.delete),
                firstOptionColor: Colors.red,
                onFirstOption: () {
                  Provider.of<MessageProvider>(context, listen: false).deleteMessage(message.id);
                  setState(() {
                    _messages.remove(message);
                  });
                },
                secondOptionIcon: Icon(Icons.close),
                secondOptionColor: Theme.of(context).colorScheme.primary,
                onSecondOption: () {},
              );
            },
          )
        ],
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
            _messages = snapshot.data;
            return RefreshIndicator(
              child: ListView(
                children: _buildMessageList(),
              ),
              onRefresh: () async {
                return Provider.of<MessageProvider>(context, listen: false).forceUpdate(widget.userID);
              },
            );
          }

          if (snapshot.hasError) {
            return RefreshIndicator(
              child: ErrorWidget(snapshot.error.toString()),
              onRefresh: () async {
                return Provider.of<MessageProvider>(context, listen: false).forceUpdate(widget.userID);
              },
            );
          }

          return Container(
            child: LinearProgressIndicator(),
          );
        },
      ),
      drawer: NavDrawer(),
    );
  }
}
