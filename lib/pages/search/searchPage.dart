import 'package:fludip/pages/search/coursePreviewWidget.dart';
import 'package:fludip/provider/course/coursePreviewModel.dart';
import 'package:fludip/provider/course/courseProvider.dart';
import 'package:fludip/util/widgets/styles.dart';
import 'package:flutter/material.dart';
import 'package:fludip/navdrawer/navDrawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  String _searchTerm;

  final TextEditingController _controller = new TextEditingController();

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Widget> _buildSearchResults(BuildContext context, List<CoursePreview> courses) {
    List<Widget> widgets = <Widget>[];

    courses.forEach((CoursePreview preview) {
      String url = Provider.of<CourseProvider>(context, listen: false).getLogo(preview.courseID);
      Future<http.Response> response = http.get(Uri.parse(url));

      widgets.add(CoursePreviewWidget(preview, response));
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("search".tr(), style: GoogleFonts.montserrat()),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
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
              builder: (BuildContext context, AsyncSnapshot<List<CoursePreview>> snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView(
                      children: _buildSearchResults(context, snapshot.data),
                    ),
                  );
                }
                return LinearProgressIndicator();
              },
            ),
          ],
        ),
      ),
      drawer: NavDrawer(),
    );
  }
}
