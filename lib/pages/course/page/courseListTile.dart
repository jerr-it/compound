import 'package:fludip/navdrawer/navDrawer.dart';
import 'package:fludip/pages/community/blubberThreadViewer.dart';
import 'package:fludip/pages/course/page/gridButton.dart';
import 'package:fludip/pages/course/tabs/files.dart';
import 'package:fludip/pages/course/tabs/forum/forum.dart';
import 'package:fludip/pages/course/tabs/members.dart';
import 'package:fludip/pages/course/tabs/info.dart';
import 'package:fludip/provider/blubber/blubberProvider.dart';
import 'package:fludip/provider/course/courseModel.dart';
import 'package:fludip/provider/course/courseProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:easy_localization/easy_localization.dart';

//TODO: List of options for which new content appeared, for example a new file upload
class CourseListTile extends StatelessWidget {
  CourseListTile(Course course, Future<http.Response> response)
      : _response = response,
        _course = course;

  Course _course;
  Future<http.Response> _response;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border(left: BorderSide(color: _course.color, width: 7.5))),
      child: ExpansionTile(
        title: Container(
          child: Row(
            children: [
              FutureBuilder(
                future: _response,
                builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.statusCode == 200) {
                      return FadeInImage(
                        placeholder: MemoryImage(kTransparentImage),
                        image: MemoryImage(snapshot.data.bodyBytes),
                        width: 32,
                        height: 32,
                      );
                    }
                    return FadeInImage(
                      placeholder: MemoryImage(kTransparentImage),
                      image: NetworkImage(Provider.of<CourseProvider>(context, listen: false).getEmptyLogo(_course.type)),
                      width: 32,
                      height: 32,
                    );
                  }
                  return CircularProgressIndicator();
                },
              ),
              VerticalDivider(),
              Flexible(
                child: Text(
                  _course.title,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(),
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
                  Navigator.push(context, navRoute(InfoTab(course: _course)));
                },
              ),
              GridButton(
                icon: Icons.forum,
                caption: "forum".tr(),
                color: Colors.red,
                onTap: () {
                  Navigator.push(
                    context,
                    navRoute(ForumTab(course: _course)),
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
                    navRoute(MembersTab(course: _course)),
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
                    navRoute(FilesTab(course: _course, path: <int>[])),
                  );
                },
              ),
              GridButton(
                icon: Icons.chat,
                caption: "blubber".tr(),
                color: Colors.amber,
                onTap: () async {
                  String threadName = _course.title;

                  await Provider.of<BlubberProvider>(context, listen: false).getOverview();
                  Navigator.push(
                    context,
                    navRoute(
                      BlubberThreadViewer(
                        name: threadName,
                        course: _course,
                      ),
                    ),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
