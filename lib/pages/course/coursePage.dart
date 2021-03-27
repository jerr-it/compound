import 'package:fludip/net/webClient.dart';
import 'package:fludip/pages/course/colorMapper.dart';
import 'package:fludip/pages/course/tabs/files.dart';
import 'package:fludip/pages/course/tabs/forum/forum.dart';
import 'package:fludip/pages/course/tabs/members.dart';
import 'package:fludip/pages/course/tabs/overview.dart';
import 'package:fludip/provider/course/fileProvider.dart';
import 'package:fludip/provider/course/forumProvider.dart';
import 'package:fludip/provider/course/membersProvider.dart';
import 'package:fludip/provider/coursesProvider.dart';
import 'package:flutter/material.dart';
import 'package:fludip/navdrawer/navDrawer.dart';
import 'package:provider/provider.dart';

//Convenience class to be used in grid view below
class GridButton extends StatelessWidget {
  final IconData _icon;
  final String _caption;
  final Color _color;
  final Function _onTap;

  GridButton({@required icon, @required caption, @required color, @required onTap})
      : _icon = icon,
        _caption = caption,
        _color = color,
        _onTap = onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _color,
      child: InkWell(
        child: Container(
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
      ),
    );
  }
}

class CoursePage extends StatelessWidget {
  List<Widget> _buildListEntries(BuildContext context, Map<String, dynamic> coursesJSON) {
    if (coursesJSON == null) {
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
    if (courses == null) {
      return widgets;
    }

    courses.forEach((courseKey, courseData) {
      String title = courseData["title"].toString();
      Color color = ColorMapper.convert(courseData["group"]);

      //TODO trailing: List of options for which new content appeared, for example a new file upload
      widgets.add(
        Container(
          decoration: BoxDecoration(border: Border(left: BorderSide(color: color, width: 7.5))),
          child: ExpansionTile(
            title: Container(
              child: Row(
                children: [
                  FlutterLogo(size: 32),
                  Flexible(
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
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
                  GridButton(
                    icon: Icons.topic,
                    caption: "Overview",
                    color: Colors.white54,
                    onTap: () {
                      Navigator.push(context, navRoute(OverviewTab(data: courseData)));
                    },
                  ),
                  GridButton(
                    icon: Icons.forum,
                    caption: "Forum",
                    color: Colors.red,
                    onTap: () {
                      if (!Provider.of<ForumProvider>(context, listen: false).initialized(courseData["course_id"])) {
                        Provider.of<ForumProvider>(context, listen: false).update(courseData["course_id"]);
                      }

                      Navigator.push(
                        context,
                        navRoute(ForumTab(
                          courseID: courseData["course_id"],
                          color: ColorMapper.convert(courseData["group"]),
                        )),
                      );
                    },
                  ),
                  GridButton(
                    icon: Icons.people,
                    caption: "Members",
                    color: Colors.green,
                    onTap: () {
                      if (!Provider.of<MembersProvider>(context, listen: false).initialized(courseData["course_id"])) {
                        Provider.of<MembersProvider>(context, listen: false).update(courseData["course_id"]);
                      }

                      Navigator.push(
                        context,
                        navRoute(MembersTab(
                          courseID: courseData["course_id"],
                          color: ColorMapper.convert(courseData["group"]),
                        )),
                      );
                    },
                  ),
                  GridButton(
                    icon: Icons.file_copy,
                    caption: "Files",
                    color: Colors.purple,
                    onTap: () {
                      if (!Provider.of<FileProvider>(context, listen: false).initialized(courseData["course_id"], <int>[])) {
                        Provider.of<FileProvider>(context, listen: false).update(courseData["course_id"], <int>[]);
                      }

                      Navigator.push(
                        context,
                        navRoute(FilesTab(
                          courseID: courseData["course_id"],
                          color: ColorMapper.convert(courseData["group"]),
                          path: <int>[],
                        )),
                      );
                    },
                  ),
                  GridButton(
                    icon: Icons.chat,
                    caption: "Blubber",
                    color: Colors.amber,
                    onTap: () async {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("open blubber"),
                      ));
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      );

      widgets.add(Divider(
        height: 0.25,
        thickness: 0.5,
      ));
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    var courses = Provider.of<CoursesProvider>(context).getData();

    return Scaffold(
      appBar: AppBar(
        title: Text("Veranstaltungen"),
      ),
      body: RefreshIndicator(
        child: ListView(
          children: _buildListEntries(context, courses),
        ),
        onRefresh: () async {
          Provider.of<CoursesProvider>(context, listen: false).update();
          return Future<void>.value(null);
        },
      ),
      drawer: NavDrawer(),
    );
  }
}
