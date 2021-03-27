import 'package:bubble/bubble.dart';
import 'package:fludip/provider/blubberProvider.dart';
import 'package:fludip/util/str.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BlubberThreadViewer extends StatefulWidget {
  Map<String, dynamic> _thread;
  String _threadName;

  BlubberThreadViewer({@required name}) : _threadName = name;

  @override
  _BlubberThreadViewerState createState() => _BlubberThreadViewerState();
}

class _BlubberThreadViewerState extends State<BlubberThreadViewer> {
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
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(comment["user_name"]),
                    Text(StringUtil.fromUnixTime(comment["chdate"] * 1000, "dd.MM.yyyy HH:mm")),
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
      body: ListView(
        reverse: true,
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        children: _buildChat(),
      ),
    );
  }
}
