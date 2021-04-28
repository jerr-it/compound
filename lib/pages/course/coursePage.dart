import 'package:fludip/util/colorMapper.dart';
import 'package:fludip/pages/course/tabs/files.dart';
import 'package:fludip/pages/course/tabs/forum/forum.dart';
import 'package:fludip/pages/course/tabs/members.dart';
import 'package:fludip/pages/course/tabs/overview.dart';
import 'package:fludip/pages/community/blubberThreadViewer.dart';
import 'package:fludip/provider/blubber/blubberProvider.dart';
import 'package:fludip/provider/course/overview/courseModel.dart';
import 'package:fludip/provider/course/overview/generalCourseProvider.dart';
import 'package:fludip/util/widgets/Nothing.dart';
import 'package:flutter/material.dart';
import 'package:fludip/navdrawer/navDrawer.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

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
  final String userID;

  CoursePage(String uID) : userID = uID;

  List<Widget> _buildListEntries(BuildContext context, List<Course> courses) {
    if (courses == null) {
      return <Widget>[Nothing()];
    }

    List<Widget> widgets = <Widget>[];
    courses.forEach((course) {
      Color color = ColorMapper.convert(course.group);

      //TODO: List of options for which new content appeared, for example a new file upload
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
                    caption: "news".tr(),
                    color: Colors.white54,
                    onTap: () {
                      Navigator.push(context, navRoute(NewsTab(course: course)));
                    },
                  ),
                  GridButton(
                    icon: Icons.forum,
                    caption: "forum".tr(),
                    color: Colors.red,
                    onTap: () {
                      Navigator.push(
                        context,
                        navRoute(ForumTab(course: course)),
                      );
                    },
                  ),
                  GridButton(
                    icon: Icons.people,
                    caption: "members".tr(),
                    color: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        navRoute(MembersTab(course: course)),
                      );
                    },
                  ),
                  GridButton(
                    icon: Icons.file_copy,
                    caption: "files".tr(),
                    color: Colors.purple,
                    onTap: () {
                      Navigator.push(
                        context,
                        navRoute(FilesTab(course: course, path: <int>[])),
                      );
                    },
                  ),
                  GridButton(
                    icon: Icons.chat,
                    caption: "blubber".tr(),
                    color: Colors.amber,
                    onTap: () async {
                      String threadName = course.title;

                      await Provider.of<BlubberProvider>(context, listen: false).getOverview();
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
    Future<List<Course>> fCourses = Provider.of<GeneralCourseProvider>(context).get(userID);

    return Scaffold(
      appBar: AppBar(
        title: Text("event".tr()),
      ),
      body: FutureBuilder(
        future: fCourses,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: RefreshIndicator(
                child: ListView(
                  children: _buildListEntries(context, snapshot.data),
                ),
                onRefresh: () async {
                  return Provider.of<GeneralCourseProvider>(context, listen: false).forceUpdate(userID);
                },
              ),
            );
          } else {
            return Container(
              child: LinearProgressIndicator(),
            );
          }
        },
      ),
      drawer: NavDrawer(),
    );
  }
}
