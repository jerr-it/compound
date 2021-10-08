import 'package:easy_localization/easy_localization.dart';
import 'package:fludip/navdrawer/navDrawer.dart';
import 'package:fludip/provider/course/courseModel.dart';
import 'package:fludip/provider/course/files/fileModel.dart';
import 'package:fludip/provider/course/files/fileProvider.dart';
import 'package:fludip/provider/course/files/folderModel.dart';
import 'package:fludip/util/dialogs/confirmDialog.dart';
import 'package:fludip/util/dialogs/fileDialog.dart';
import 'package:fludip/util/mimeTypeMapper.dart';
import 'package:fludip/util/widgets/Nothing.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

// Fludip - Mobile StudIP client
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

class FilesTab extends StatelessWidget {
  Course _course;
  List<int> _subFolderPath;

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
        leading: fileRef.url != null ? Icon(Icons.link_sharp) : MIME_TO_ICON(fileRef.mimeType),
        title: Text(fileRef.name, style: GoogleFonts.montserrat()),
        onTap: () async {
          //TODO Show file dialog
          var storagePerm = await Permission.storage.request();

          if (!storagePerm.isGranted) {
            ConfirmDialog.display(
              context,
              title: "no-permission".tr(),
              leading: Icon(Icons.warning_sharp),
              subtitle: "no-permission-body".tr(),
              firstOption: "ok".tr(),
              secondOption: "settings".tr(),
              onFirstOption: () {},
              onSecondOption: () {
                openAppSettings();
              },
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
          } else {
            return Container(
              child: LinearProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
