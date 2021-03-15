import 'package:fludip/pages/events/eventviewer.dart';
import 'package:fludip/provider/events.dart';
import 'package:flutter/material.dart';
import 'package:fludip/navdrawer/navdrawer.dart';
import 'package:provider/provider.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  List<Widget> _buildListEntries(Map<String,dynamic> coursesJSON) {
    if(coursesJSON == null){
      var ret = <Widget>[];
      ret.add(Container(
        margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: ListTile(
          title: Text("No courses found!"),
          subtitle: Text("Try again later..."),
        ),
      ));
      return ret;
    }

    Map<String, dynamic> courses = coursesJSON["collection"];
    List<Widget> widgets = <Widget>[];

    courses.forEach((courseKey, courseData) {
      String title = courseData["title"].toString();
      String description = courseData["description"].toString();

      String lecturers = "";
      String location = courseData["location"].toString();

      //Gather lecturers
      Map<String, dynamic> lecturerData = courseData["lecturers"];
      lecturerData.forEach((lecturerID, lecturerData) {
        lecturers += lecturerData["name"]["formatted"].toString() + ", ";
      });
      lecturers = lecturers.substring(0, lecturers.length-2);

      //TODO colors according to user settings, green for now
      //TODO replace flutter logo with something useful
      widgets.add(Card(
        shape: Border(left: BorderSide(color:Colors.green,width: 5)),
        child: ExpansionTile(
          title: Container(
            child: Row(
              children: [
                FlutterLogo(size: 32,),
                Flexible(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Icon(Icons.location_on),
                    Text(location),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.people),
                    Text(lecturers),
                  ],
                )
              ],
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //TODO new files comments etc indicators here (red marks in the web)
                  IconButton(
                    icon: Icon(Icons.login),
                    onPressed: (){
                      Navigator.push(context, navRoute(EventViewer(eventData: courseData)));
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ));
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {

    var courses = Provider.of<EventProvider>(context).getData();

    return Scaffold(
      appBar: AppBar(
        title: Text("Veranstaltungen"),
      ),
      body: RefreshIndicator(
        child: ListView(
          children: _buildListEntries(courses),
        ),
        onRefresh: (){
          return Future<void>.value(null);
        },
      ),
      drawer: NavDrawer(),
    );
  }
}
