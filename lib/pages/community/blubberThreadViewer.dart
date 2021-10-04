import 'dart:async';

import 'package:bubble/bubble.dart';
import 'package:fludip/provider/blubber/blubberMessageModel.dart';
import 'package:fludip/provider/blubber/blubberThreadModel.dart';
import 'package:fludip/provider/blubber/blubberProvider.dart';
import 'package:fludip/provider/course/courseModel.dart';
import 'package:fludip/util/str.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class BlubberThreadViewer extends StatefulWidget {
  Future<BlubberThread> _thread;
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

  List<Widget> _buildChat(BlubberThread thread) {
    List<Widget> widgets = <Widget>[];

    List<BlubberMessage> comments = thread.comments;
    comments.forEach((comment) {
      widgets.add(
        Padding(
          padding: EdgeInsets.all(5),
          child: Bubble(
            alignment: comment.isMine ? Alignment.topRight : Alignment.bottomLeft,
            nip: comment.isMine ? BubbleNip.rightTop : BubbleNip.leftBottom,
            color: comment.isMine ? Colors.lightGreen : Colors.white30,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: comment.isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      comment.userName,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                    ),
                    Text(
                      ", " + StringUtil.fromUnixTime(comment.chdate * 1000, "HH:mm"),
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
                Text(comment.content),
              ],
            ),
          ),
        ),
      );
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    widget._thread = Provider.of<BlubberProvider>(context).getThread(widget._threadName);

    return FutureBuilder(
      future: widget._thread,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var bThread = snapshot.data as BlubberThread;
          if (bThread.id == null) {
            return Scaffold(
              appBar: AppBar(
                title: Text(snapshot.data.name),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                backgroundColor: this.widget._course != null ? this.widget._course.color : Colors.blue,
              ),
              body: Center(
                heightFactor: 2,
                child: Text(
                  "blubber-not-enabled".tr(),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(snapshot.data.name),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              backgroundColor: this.widget._course != null ? this.widget._course.color : Colors.blue,
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
              title: Text("blubber".tr()),
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
