import 'dart:async';

import 'package:compound/pages/community/blubberMessageBubble.dart';
import 'package:compound/provider/blubber/blubberMessageModel.dart';
import 'package:compound/provider/blubber/blubberProvider.dart';
import 'package:compound/provider/blubber/blubberThreadModel.dart';
import 'package:compound/provider/course/courseModel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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

///Displays a given Blubber thread
class BlubberThreadViewer extends StatefulWidget {
  final Course _course;
  final String _threadName;
  final TextEditingController _tController = TextEditingController();

  BlubberThreadViewer({@required name, course})
      : _threadName = name,
        _course = course;

  @override
  _BlubberThreadViewerState createState() => _BlubberThreadViewerState();
}

class _BlubberThreadViewerState extends State<BlubberThreadViewer> {
  Timer timer;
  Future<BlubberThread> _thread;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 15), (timer) {
      Provider.of<BlubberProvider>(context, listen: false).forceUpdateThread(widget._threadName);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  ///Populates the listview with the threads comments
  List<Widget> _buildChat(BlubberThread thread) {
    List<Widget> widgets = <Widget>[];

    List<BlubberMessage> comments = thread.comments;
    comments.forEach((comment) {
      widgets.add(BlubberMessageBubble(comment));
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    _thread = Provider.of<BlubberProvider>(context).getThread(widget._threadName);

    return FutureBuilder(
      future: _thread,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var bThread = snapshot.data as BlubberThread;
          if (bThread.id == null) {
            return Scaffold(
              appBar: AppBar(
                title: Text(snapshot.data.name, style: GoogleFonts.montserrat()),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: Center(
                heightFactor: 2,
                child: Text(
                  "blubber-not-enabled".tr(),
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(snapshot.data.name, style: GoogleFonts.montserrat()),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              backgroundColor:
                  this.widget._course != null ? this.widget._course.color : Theme.of(context).colorScheme.primary,
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView(
                    reverse: true,
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    children: _buildChat(snapshot.data),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                  ),
                  child: Stack(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: TextField(controller: widget._tController),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: IconButton(
                            color: Colors.blue,
                            icon: Icon(Icons.send),
                            onPressed: () async {
                              Provider.of<BlubberProvider>(context, listen: false).postMessage(
                                snapshot.data.id,
                                widget._tController.text,
                              );

                              widget._tController.clear();
                              Future.delayed(Duration(seconds: 1)).then((value) {
                                return Provider.of<BlubberProvider>(context, listen: false)
                                    .forceUpdateThread(widget._threadName);
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text("blubber".tr(), style: GoogleFonts.montserrat()),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              backgroundColor: this.widget._course != null ? this.widget._course.color : Colors.blue,
            ),
            body: Container(
              child: LinearProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
