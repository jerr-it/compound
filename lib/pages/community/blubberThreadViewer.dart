import 'dart:async';

import 'package:bubble/bubble.dart';
import 'package:fludip/net/webClient.dart';
import 'package:fludip/provider/blubberProvider.dart';
import 'package:fludip/util/str.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BlubberThreadViewer extends StatefulWidget {
  Map<String, dynamic> _thread;
  String _threadName;
  final TextEditingController _tController = TextEditingController();

  BlubberThreadViewer({@required name}) : _threadName = name;

  @override
  _BlubberThreadViewerState createState() => _BlubberThreadViewerState();
}

class _BlubberThreadViewerState extends State<BlubberThreadViewer> {
  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 15), (timer) {
      Provider.of<BlubberProvider>(context, listen: false).fetchThread(widget._threadName);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  List<Widget> _buildChat() {
    List<Widget> widgets = <Widget>[];
    if (widget._thread == null) {
      return widgets;
    }

    List<dynamic> comments = widget._thread["comments"];
    comments.forEach((comment) {
      widgets.add(
        Padding(
          padding: EdgeInsets.all(5),
          child: Bubble(
            alignment: comment["class"] == "mine" ? Alignment.topRight : Alignment.bottomLeft,
            nip: comment["class"] == "mine" ? BubbleNip.rightTop : BubbleNip.leftBottom,
            color: comment["class"] == "mine" ? Colors.lightGreen : Colors.white30,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: comment["class"] == "mine" ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      comment["user_name"],
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                    ),
                    Text(
                      ", " + StringUtil.fromUnixTime(comment["chdate"] * 1000, "HH:mm"),
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
                Text(comment["content"]),
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

    return Scaffold(
      appBar: AppBar(
        title: widget._thread == null ? Text("Blubber") : Text(widget._thread["thread_posting"]["name"]),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              children: _buildChat(),
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
                        //TODO post mechanic
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
  }
}
