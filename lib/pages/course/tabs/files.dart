import 'package:compound/navdrawer/navDrawer.dart';
import 'package:compound/provider/course/courseModel.dart';
import 'package:compound/provider/course/files/fileModel.dart';
import 'package:compound/provider/course/files/fileProvider.dart';
import 'package:compound/provider/course/files/folderModel.dart';
import 'package:compound/util/dialogs/confirmDialog.dart';
import 'package:compound/util/dialogs/fileDialog.dart';
import 'package:compound/util/mimeTypeMapper.dart';
import 'package:compound/util/widgets/Nothing.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
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

///Displays a folders content
class FilesTab extends StatelessWidget {
  final Course _course;
  final List<int> _subFolderPath;

  FilesTab({@required course, @required path})
      : _course = course,
        _subFolderPath = path;

  List<Widget> _buildFileList(BuildContext context, Folder currentFolder) {
    List<Widget> widgets = <Widget>[];
    if (currentFolder == null) {
      return widgets;
    }

    List<Folder> subfolders = currentFolder.subFolders;
    if (subfolders == null) {
      return widgets;
    }

    for (int i = 0; i < subfolders.length; i++) {
      Folder subfolder = subfolders[i];

      if (subfolder.name == null) {
        continue;
      }

      widgets.add(ListTile(
        leading: Icon(Icons.folder),
        title: Text(subfolder.name, style: GoogleFonts.montserrat()),
        onTap: () async {
          List<int> subPath = <int>[];
          subPath.addAll(_subFolderPath);
          subPath.add(i);

          Navigator.push(
            context,
            navRoute(FilesTab(
              course: _course,
              path: subPath,
            )),
          );
        },
      ));
    }

    List<File> fileRefs = currentFolder.files;
    fileRefs.forEach((fileRef) {
      widgets.add(ListTile(
        leading: fileRef.url != null ? Icon(Icons.link_sharp) : mimeToIcon(fileRef.mimeType),
        title: Text(fileRef.name, style: GoogleFonts.montserrat()),
        onTap: () async {
          var storagePerm = await Permission.storage.request();

          if (!storagePerm.isGranted) {
            ConfirmDialog.display(
              context,
              title: "no-permission".tr(),
              leading: Icon(Icons.warning_sharp),
              subtitle: "no-permission-body".tr(),
              firstOptionIcon: Icon(Icons.settings),
              secondOptionIcon: Icon(Icons.close),
              onFirstOption: () {
                openAppSettings();
              },
              onSecondOption: () {},
            );
            return;
          }
          FileDialog.display(context, file: fileRef);
        },
      ));
    });

    if (widgets.isEmpty) {
      widgets.add(Nothing());
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    Future<Folder> folder = Provider.of<FileProvider>(context).get(_course.courseID, _subFolderPath);

    return Scaffold(
      appBar: AppBar(
        title: Text("files".tr(), style: GoogleFonts.montserrat()),
        backgroundColor: _course.color,
      ),
      body: FutureBuilder(
        future: folder,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              child: Container(
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  children: _buildFileList(context, snapshot.data),
                ),
              ),
              onRefresh: () async {
                return Provider.of<FileProvider>(context, listen: false).forceUpdate(_course.courseID, _subFolderPath);
              },
            );
          }

          if (snapshot.hasError) {
            return RefreshIndicator(
              child: ErrorWidget(snapshot.error.toString()),
              onRefresh: () async {
                return Provider.of<FileProvider>(context, listen: false).forceUpdate(_course.courseID, _subFolderPath);
              },
            );
          }

          return Container(
            child: LinearProgressIndicator(),
          );
        },
      ),
    );
  }
}
