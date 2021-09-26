import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ForumReplyScreen extends StatelessWidget {
  const ForumReplyScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          child: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: Text("reply".tr()),
      ),
      body: SizedBox(
        width: double.maxFinite,
        child: Container(
          child: Column(
            children: [
              TextField(
                maxLines: null,
                controller: controller,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send),
        onPressed: () {
          Navigator.pop(context, controller.text);
        },
      ),
    );
  }
}
