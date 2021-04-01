import 'package:fludip/pages/course/colorMapper.dart';
import 'package:fludip/pages/course/tabs/files.dart';
import 'package:fludip/pages/course/tabs/forum/forum.dart';
import 'package:fludip/pages/course/tabs/members.dart';
import 'package:fludip/pages/course/tabs/overview.dart';
import 'package:fludip/pages/community/blubberThreadViewer.dart';
import 'package:fludip/provider/blubberProvider.dart';
import 'package:fludip/provider/course/files/fileProvider.dart';
import 'package:fludip/provider/course/forum/forumProvider.dart';
import 'package:fludip/provider/course/members/membersProvider.dart';
import 'package:fludip/provider/course/overview/courseModel.dart';
import 'package:fludip/provider/course/overview/generalCourseProvider.dart';
import 'package:fludip/util/commonWidgets.dart';
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
  List<Widget> _buildListEntries(BuildContext context, List<Course> courses) {
    if (courses == null) {
      return <Widget>[CommonWidgets.nothing()];
    }

    List<Widget> widgets = <Widget>[];
    courses.forEach((course) {
      Color color = ColorMapper.convert(course.group);

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
                      course.title,
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
                    icon: Icons.new_releases_sharp,
                    caption: "News",
                    color: Colors.white54,
                    onTap: () {
                      Navigator.push(context, navRoute(NewsTab(data: course)));
                    },
                  ),
                  GridButton(
                    icon: Icons.forum,
                    caption: "Forum",
                    color: Colors.red,
                    onTap: () async {
                      if (!Provider.of<ForumProvider>(context, listen: false).initialized(course.courseID)) {
                        await Provider.of<ForumProvider>(context, listen: false).updateCategories(course.courseID);
                      }

                      Navigator.push(
                        context,
                        navRoute(ForumTab(
                          courseID: course.courseID,
                          color: ColorMapper.convert(course.group),
                        )),
                      );
                    },
                  ),
                  GridButton(
                    icon: Icons.people,
                    caption: "Members",
                    color: Colors.green,
                    onTap: () {
                      if (!Provider.of<MembersProvider>(context, listen: false).initialized(course.courseID)) {
                        Provider.of<MembersProvider>(context, listen: false).update(course.courseID);
                      }

                      Navigator.push(
                        context,
                        navRoute(MembersTab(
                          courseID: course.courseID,
                          color: ColorMapper.convert(course.group),
                        )),
                      );
                    },
                  ),
                  GridButton(
                    icon: Icons.file_copy,
                    caption: "Files",
                    color: Colors.purple,
                    onTap: () {
                      if (!Provider.of<FileProvider>(context, listen: false).initialized(course.courseID, <int>[])) {
                        Provider.of<FileProvider>(context, listen: false).update(course.courseID, <int>[]);
                      }

                      Navigator.push(
                        context,
                        navRoute(FilesTab(
                          courseID: course.courseID,
                          color: ColorMapper.convert(course.group),
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
                      String threadName = course.title;
                      if (!Provider.of<BlubberProvider>(context, listen: false).initialized()) {
                        await Provider.of<BlubberProvider>(context, listen: false).fetchOverview();
                      }
                      if (!Provider.of<BlubberProvider>(context, listen: false).threadInitialized(threadName)) {
                        await Provider.of<BlubberProvider>(context, listen: false).fetchThread(threadName);
                      }

                      Navigator.push(context, navRoute(BlubberThreadViewer(name: threadName)));
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
    List<Course> courses = Provider.of<GeneralCourseProvider>(context).courses();

    return Scaffold(
      appBar: AppBar(
        title: Text("Veranstaltungen"),
      ),
      body: RefreshIndicator(
        child: ListView(
          children: _buildListEntries(context, courses),
        ),
        onRefresh: () async {
          Provider.of<GeneralCourseProvider>(context, listen: false).update();
          return Future<void>.value(null);
        },
      ),
      drawer: NavDrawer(),
    );
  }
}
