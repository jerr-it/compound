import 'package:easy_localization/easy_localization.dart';
import 'package:fludip/navdrawer/navDrawer.dart';
import 'package:fludip/pages/community/blubberThreadViewer.dart';
import 'package:fludip/provider/blubber/blubberProvider.dart';
import 'package:fludip/provider/blubber/blubberThreadModel.dart';
import 'package:fludip/util/str.dart';
import 'package:fludip/util/widgets/Nothing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CommunityPage extends StatelessWidget {
  List<Widget> _buildOverview(BuildContext context, List<BlubberThread> threads) {
    List<Widget> widgets = <Widget>[];
    if (threads.isEmpty) {
      return <Widget>[Nothing()];
    }

    threads.forEach((thread) {
      if (thread.avatarUrl == null) {
        return;
      }
      Widget leading;
      if (thread.avatarUrl.contains(".svg")) {
        leading = SvgPicture.network(
          thread.avatarUrl,
          width: 30,
          height: 30,
        );
      } else {
        leading = Image.network(
          thread.avatarUrl,
          width: 30,
          height: 30,
        );
      }

      widgets.add(ListTile(
        leading: leading,
        title: Text(thread.name),
        subtitle: Text(StringUtil.fromUnixTime(thread.timeStamp * 1000, "dd.MM.yyyy HH:mm")),
        onTap: () async {
          Navigator.push(context, navRoute(BlubberThreadViewer(name: thread.name)));
        },
      ));

      widgets.add(Divider());
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    Future<List<BlubberThread>> threads = Provider.of<BlubberProvider>(context).getOverview();

    return Scaffold(
      appBar: AppBar(
        title: Text("community".tr()),
      ),
      body: FutureBuilder(
        future: threads,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: RefreshIndicator(
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  children: _buildOverview(context, snapshot.data),
                ),
                onRefresh: () {
                  return Provider.of<BlubberProvider>(context).forceUpdateOverview();
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
