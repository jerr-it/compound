import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';

class ForumReplyScreen extends StatelessWidget {
  const ForumReplyScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, null);
          },
        ),
        title: Text("reply".tr(), style: GoogleFonts.montserrat()),
      ),
      body: SizedBox(
        width: double.maxFinite,
        child: Container(
          child: Column(
            children: [
              TextField(
                maxLines: null,
                controller: controller,
                style: GoogleFonts.montserrat(),
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
