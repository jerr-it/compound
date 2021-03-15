import 'package:fludip/provider/events.dart';
import 'package:flutter/material.dart';
import 'package:fludip/navdrawer/navdrawer.dart';
import 'package:provider/provider.dart';

//Convenience class to be used in grid view below
class GridButton extends StatelessWidget {
  final IconData _icon;
  final String _caption;
  final Color _color;
  final Function _onTap;

  GridButton({@required icon, @required caption, @required color, @required onTap})
  : _icon = icon, _caption = caption, _color = color, _onTap = onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        color: _color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(_icon),
            Text(_caption),
          ],
        ),
      ),
      onTap: _onTap,
    );
  }
}

class CoursePage extends StatelessWidget {
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
      //TODO let user set which actions should be on the slideshow
      //TODO trailing: List of options for which new content appeared, for example a new file upload
      widgets.add(
          Container(
              decoration: BoxDecoration(
                  border: Border(left: BorderSide(color: Colors.green, width: 5.0))
              ),
              child: ExpansionTile(
                title: Container(
                  child: Row(
                    children: [
                      FlutterLogo(size:32),
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
                  GridView.count(
                    crossAxisCount: 4,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    children: [
                      GridButton(icon: Icons.topic, caption: "Overview", color: Colors.white, onTap: (){
                        //TODO page route
                      }),
                      GridButton(icon: Icons.forum, caption: "Forum", color: Colors.red, onTap: (){
                        //TODO page route
                      }),
                      GridButton(icon: Icons.people, caption: "Participants", color: Colors.green, onTap: (){
                        //TODO page route
                      }),
                      GridButton(icon: Icons.file_copy, caption: "Files", color: Colors.purple, onTap: (){
                        //TODO page route
                      }),
                      GridButton(icon: Icons.auto_stories, caption: "Schedule", color: Colors.orange, onTap: (){
                        //TODO page route
                      }),
                      GridButton(icon: Icons.info, caption: "Information", color: Colors.pink, onTap: (){
                        //TODO page route
                      }),
                      GridButton(icon: Icons.article_rounded, caption: "Wiki", color: Colors.lime, onTap: (){
                        //TODO page route
                      }),
                      GridButton(icon: Icons.ad_units, caption: "Blubber", color: Colors.indigoAccent, onTap: (){
                        //TODO page route
                      }),
                    ],
                  )
                ],
              )
          )
      );

      widgets.add(Divider(height: 0.25,thickness: 0.5,));
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
