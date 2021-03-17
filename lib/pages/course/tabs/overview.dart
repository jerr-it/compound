import 'package:fludip/pages/course/colormapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class OverviewTab extends StatefulWidget {
  final Map<String, dynamic> _courseData;

  OverviewTab({@required data})
  : _courseData = data;

  @override
  _OverviewTabState createState() => _OverviewTabState();
}

class _OverviewTabState extends State<OverviewTab> {

  ///Helper to get list of formatted lecturer names from this course
  List<Widget> _gatherLecturers(){
    List<Widget> widgets = <Widget>[];

    widgets.add(Text(
      "Lecturers",
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ));

    Map<String, dynamic> lecturerData = widget._courseData["lecturers"];
    lecturerData.forEach((lecturerID, lecturerData) {
      //lecturers.add(lecturerData["name"]["formatted"].toString());
      widgets.add(Text(
        "     \u2022" + lecturerData["name"]["formatted"].toString(),
        textAlign: TextAlign.right,
      ));
    });

    return widgets;
  }

  ///Helper to get list of announcements from this course
  List<Widget> _gatherAnnouncements(){
    List<Widget> widgets = <Widget>[];

    widgets.add(Text(
      "Announcements",
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ));

    Map<String, dynamic> announcementData;
    try{
      announcementData = widget._courseData["announcements"]["collection"];
    }catch(e){
      return widgets;
    }

    final DateFormat formatter = DateFormat("dd.MM.yyyy HH:mm");

    announcementData.forEach((key, value) {
      String topic = value["topic"].toString();
      String body = value["body"].toString(); //TODO get rid of html stuff

      DateTime dateTime = new DateTime.fromMillisecondsSinceEpoch(
          int.parse(value["date"].toString()) * 1000);
      String date = formatter.format(dateTime);

      widgets.add(Card(
        child: ExpansionTile(
          title: Container(
            child: Row(
              children: [
                FlutterLogo(
                  size: 32,
                ),
                Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          topic,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          date,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ),
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: Text(body),
            )
          ],
        ),
      ));
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Overview: " + widget._courseData["title"]),
        backgroundColor: ColorMapper.convert(widget._courseData["group"]),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Number",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget._courseData["number"] != "" ? "     " + widget._courseData["number"] : "     " + "None",
                )
              ],
            ),
            Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _gatherLecturers(),
            ),
            Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Semester",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                    "     " + (widget._courseData["start_semester"] != null ? widget._courseData["start_semester"]["title"] : "unlimited")
                      + " - "
                      + (widget._courseData["end_semester"] != null ? widget._courseData["end_semester"]["title"] : "unlimited")
                ),
              ],
            ),
            Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Location",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "     " + widget._courseData["location"] != null ? widget._courseData["location"] : "None",
                )
              ],
            ),
            Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _gatherAnnouncements(),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
