import 'package:fludip/pages/search/coursePreviewWidget.dart';
import 'package:fludip/provider/course/courseModel.dart';
import 'package:fludip/provider/course/coursePreviewModel.dart';
import 'package:fludip/provider/course/courseProvider.dart';
import 'package:fludip/provider/course/semester/semesterFilter.dart';
import 'package:fludip/provider/course/semester/semesterModel.dart';
import 'package:fludip/provider/course/semester/semesterProvider.dart';
import 'package:fludip/util/widgets/styles.dart';
import 'package:flutter/material.dart';
import 'package:fludip/navdrawer/navDrawer.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  SearchPage(String userID) : _userID = userID;

  String _searchTerm;

  final TextEditingController _controller = new TextEditingController();
  final String _userID;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Widget> _buildSearchResults(BuildContext context, List<CoursePreview> courses, List<Course> signedUpCourses) {
    List<Widget> widgets = <Widget>[];

    courses.forEach((CoursePreview preview) {
      widgets.add(Row(
        children: [
          Expanded(child: CoursePreviewWidget(preview)),
          signedUpCourses.firstWhere((sCourse) => sCourse.courseID == preview.courseID, orElse: () => null) == null
              ? Container(
                  child: ElevatedButton(
                    onPressed: () async {
                      http.Response response =
                          await Provider.of<CourseProvider>(context, listen: false).signup(preview.courseID);
                      print(response);
                    },
                    style: RAISED_ICON_BUTTON_STYLE(Colors.blue),
                    child: Icon(FontAwesome.sign_in),
                  ),
                  padding: EdgeInsets.only(right: 5),
                )
              : Container(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Icon(Icons.check, color: Colors.white),
                    style: RAISED_ICON_BUTTON_STYLE(Colors.green),
                  ),
                  padding: EdgeInsets.only(right: 5),
                ),
        ],
      ));
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    //TODO filter support here as well (See courseProvider 'searchFor' method)
    List<Semester> semesters =
        Provider.of<SemesterProvider>(context, listen: false).get(SemesterFilter(FilterType.ALL, null));
    Future<List<Course>> courses =
        Provider.of<CourseProvider>(context, listen: false).get(context, this.widget._userID, semesters);

    return Scaffold(
      appBar: AppBar(
        title: Text("search".tr(), style: GoogleFonts.montserrat()),
      ),
      body: FutureBuilder(
        future: courses,
        builder: (BuildContext context, AsyncSnapshot<List<Course>> signedUpSnapshot) {
          if (signedUpSnapshot.hasData) {
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      TextField(
                        controller: this.widget._controller,
                        style: GoogleFonts.montserrat(),
                        decoration: InputDecoration(
                          hintText: "search-text".tr(),
                          hintStyle: GoogleFonts.montserrat(color: Colors.black26),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black38, width: 2),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12, width: 2),
                          ),
                        ),
                        onSubmitted: (_) {
                          setState(() {
                            this.widget._searchTerm = this.widget._controller.text;
                          });
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            this.widget._searchTerm = this.widget._controller.text;
                          });
                        },
                        child: Icon(Icons.search),
                        style: RAISED_ICON_BUTTON_STYLE(Colors.blue),
                      ),
                    ],
                  ),
                ),
                FutureBuilder(
                  future: Provider.of<CourseProvider>(context, listen: false).searchFor(context, this.widget._searchTerm),
                  builder: (BuildContext context, AsyncSnapshot<List<CoursePreview>> previewSnapshot) {
                    if (previewSnapshot.hasData) {
                      return Expanded(
                        child: ListView(
                          children: _buildSearchResults(context, previewSnapshot.data, signedUpSnapshot.data),
                        ),
                      );
                    }
                    return LinearProgressIndicator();
                  },
                ),
              ],
            );
          }
          return LinearProgressIndicator();
        },
      ),
      drawer: NavDrawer(),
    );
  }
}
