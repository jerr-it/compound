import 'package:compound/navdrawer/navDrawer.dart';
import 'package:compound/provider/course/courseModel.dart';
import 'package:compound/provider/course/courseProvider.dart';
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

    //Display new files
    bool hasNewFiles = Provider.of<CourseProvider>(context, listen: false).parser.hasNew(_course.number, "files");
    if (hasNewFiles) {
      List<File> newFiles = Provider.of<FileProvider>(context, listen: false).newFiles;

      newFiles.forEach((File file) {
        widgets.add(ListTile(
          leading: file.url != null ? Icon(Icons.link_sharp) : mimeToIcon(file.mimeType),
          title: Text(file.name, style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
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
            FileDialog.display(context, file: file);
          },
        ));
      });
    }

    //Display folders
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

    //Display files
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
    bool hasNew = Provider.of<CourseProvider>(context).parser.hasNew(_course.number, "files");
    Future<Folder> folder = Provider.of<FileProvider>(context).get(_course.courseID, _subFolderPath, hasNew);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("files".tr(), style: GoogleFonts.montserrat()),
            Hero(
              tag: "files".tr(),
              child: Icon(Icons.file_copy),
            ),
          ],
        ),
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
                return Provider.of<FileProvider>(context, listen: false)
                    .forceUpdate(_course.courseID, _subFolderPath, hasNew);
              },
            );
          }

          if (snapshot.hasError) {
            return RefreshIndicator(
              child: ErrorWidget(snapshot.error.toString()),
              onRefresh: () async {
                return Provider.of<FileProvider>(context, listen: false)
                    .forceUpdate(_course.courseID, _subFolderPath, hasNew);
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
