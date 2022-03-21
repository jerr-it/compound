import 'package:compound/navdrawer/navDrawer.dart';
import 'package:compound/pages/community/blubberThreadViewer.dart';
import 'package:compound/provider/blubber/blubberProvider.dart';
import 'package:compound/provider/blubber/blubberThreadModel.dart';
import 'package:compound/util/str.dart';
import 'package:compound/util/widgets/Nothing.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

// Compound - Mobile StudIP client
// Copyright (C) 2021 Jerrit Gläsker

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

///Displays all available blubber threads
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
          }

          if (snapshot.hasError) {
            return RefreshIndicator(
              child: ErrorWidget(snapshot.error.toString()),
              onRefresh: () {
                return Provider.of<BlubberProvider>(context).forceUpdateOverview();
              },
            );
          }

          return Container(
            child: LinearProgressIndicator(),
          );
        },
      ),
      drawer: NavDrawer(),
    );
  }
}
