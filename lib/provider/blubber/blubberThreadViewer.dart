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
      if (comment["class"] == "mine") {
        widgets.add(
          Padding(
            padding: EdgeInsets.all(5),
            child: Bubble(
              alignment: Alignment.topRight,
              nip: BubbleNip.rightTop,
              color: Colors.lightGreen,
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
      } else {
        widgets.add(
          Padding(
            padding: EdgeInsets.all(5),
            child: Bubble(
              alignment: Alignment.topLeft,
              nip: BubbleNip.leftTop,
              color: Colors.white,
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
      }
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
