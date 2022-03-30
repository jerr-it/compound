import 'package:compound/navdrawer/navDrawer.dart';
import 'package:compound/provider/course/wiki/wikiModel.dart';
import 'package:compound/provider/course/wiki/wikiProvider.dart';
import 'package:compound/util/widgets/Nothing.dart';
import 'package:compound/util/widgets/routeError.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class WikiPage extends StatelessWidget {
  const WikiPage(String courseID, String pageName)
      : _courseID = courseID,
        _pageName = pageName;

  final String _courseID;
  final String _pageName;

  List<Widget> _buildPageList(BuildContext context, Map<String, WikiPageModel> pages) {
    if (pages.isEmpty) {
      return [Nothing()];
    }

    List<Widget> widgets = [];
    pages.forEach((String keyword, WikiPageModel page) {
      widgets.add(ListTile(
        title: Text(page.keyword == "WikiWikiWeb" ? "Start page" : page.keyword),
        trailing: Text("Version " + page.version.toString()),
        onTap: () {
          Navigator.pushReplacement(context, navRoute(WikiPage(_courseID, page.keyword)));
        },
      ));
    });

    return widgets.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    Future<Map<String, WikiPageModel>> pages = Provider.of<WikiProvider>(context).getPages(_courseID);
    Future<WikiPageModel> page = Provider.of<WikiProvider>(context).getPage(_courseID, _pageName);

    final PreferredSizeWidget appBar = AppBar(
      title: Text("wiki".tr()),
      actions: [
        Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
            icon: Icon(MaterialCommunityIcons.file_tree),
          ),
        ),
      ],
    );

    double height = MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: appBar,
      body: FutureBuilder(
        future: page,
        builder: (BuildContext context, AsyncSnapshot<WikiPageModel> snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
                  child: Html(
                    data: snapshot.data.content,
                  ),
                  height: height,
                ),
              ),
              onRefresh: () async {
                return Provider.of<WikiProvider>(context, listen: false).forceUpdate(_courseID, _pageName);
              },
            );
          }

          if (snapshot.hasError) {
            return RouteErrorWidget(snapshot.error, () {
              return Provider.of<WikiProvider>(context, listen: false).getPage(_courseID, _pageName);
            });
          }

          return LinearProgressIndicator();
        },
      ),
      drawer: NavDrawer(),
      endDrawer: Drawer(
        child: FutureBuilder(
          future: pages,
          builder: (BuildContext context, AsyncSnapshot<Map<String, WikiPageModel>> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: _buildPageList(context, snapshot.data),
              );
            }

            if (snapshot.hasError) {
              return RouteErrorWidget(snapshot.error, () {
                return Provider.of<WikiProvider>(context, listen: false).forceUpdatePages(_courseID);
              });
            }

            return LinearProgressIndicator();
          },
        ),
      ),
    );
  }
}
