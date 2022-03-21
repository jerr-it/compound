import 'package:compound/provider/messages/messageModel.dart';
import 'package:compound/util/str.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

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

///View the contents of a message
class MessageViewer extends StatelessWidget {
  final Message _message;

  MessageViewer({@required message}) : _message = message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          leading: Image.network(
            _message.sender.avatarUrlMedium,
            width: 40,
            height: 40,
          ),
          title: Text(_message.sender.email),
          subtitle: Text(
            StringUtil.fromUnixTime(_message.mkdate * 1000, "dd.MM.yyyy HH:mm"),
            style: TextStyle(
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 7.5),
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 7.5),
          children: [
            Text(
              _message.subject,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.normal,
              ),
            ),
            Html(data: _message.content),
          ],
        ),
      ),
    );
  }
}
