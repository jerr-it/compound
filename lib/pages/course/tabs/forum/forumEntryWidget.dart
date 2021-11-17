import 'package:compound/provider/course/forum/entryModel.dart';
import 'package:compound/util/str.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';

class ForumEntryWidget extends StatelessWidget {
  ForumEntryWidget(ForumEntry entry, {bool isNew = false})
      : _entry = entry,
        _isNew = isNew;

  final ForumEntry _entry;
  final bool _isNew;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey[800]),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Flexible(
            flex: 3,
            child: Column(
              children: [
                CircleAvatar(
                  minRadius: 10,
                  maxRadius: 25,
                  backgroundImage: NetworkImage(_entry.user.avatarUrlMedium),
                ),
                Text(
                  _entry.user.formattedName,
                  style: GoogleFonts.montserrat(fontWeight: FontWeight.w300),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
          VerticalDivider(),
          Flexible(
            flex: 9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Html(
                  data: _entry.content,
                  style: {
                    "*": Style(fontFamily: GoogleFonts.montserrat().fontFamily),
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    StringUtil.fromUnixTime(_entry.mkdate * 1000, "dd.MM.yyyy HH:mm") +
                        (_isNew ? "\t" + _entry.subject.replaceAll("&gt;&gt;", ">>") : ""),
                    style: GoogleFonts.montserrat(fontWeight: FontWeight.w200),
                    textAlign: TextAlign.right,
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
