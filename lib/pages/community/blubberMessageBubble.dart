import 'package:bubble/bubble.dart';
import 'package:compound/provider/blubber/blubberMessageModel.dart';
import 'package:compound/util/str.dart';
import 'package:flutter/material.dart';

///Creates a message bubble shape widget for a blubber message
class BlubberMessageBubble extends StatelessWidget {
  BlubberMessageBubble(BlubberMessage message) : comment = message;

  final BlubberMessage comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Bubble(
        alignment: comment.isMine ? Alignment.topRight : Alignment.bottomLeft,
        nip: comment.isMine ? BubbleNip.rightTop : BubbleNip.leftBottom,
        color: comment.isMine ? Theme.of(context).colorScheme.primary : Theme.of(context).dialogBackgroundColor,
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
    );
  }
}
