import 'package:fludip/navdrawer/navDrawer.dart';
import 'package:fludip/provider/course/files/fileModel.dart';
import 'package:fludip/provider/course/files/fileProvider.dart';
import 'package:fludip/provider/course/files/folderModel.dart';
import 'package:fludip/provider/course/overview/courseModel.dart';
import 'package:fludip/util/colorMapper.dart';
import 'package:fludip/util/commonWidgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        title: Text(subfolder.name),
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
        leading: Icon(Icons.file_copy),
        title: Text(fileRef.name),
        onTap: () {
          //TODO download file
        },
      ));
    });

    if (widgets.isEmpty) {
      widgets.add(CommonWidgets.nothing());
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    Future<Folder> folder = Provider.of<FileProvider>(context).get(_course.courseID, _subFolderPath);

    return Scaffold(
      appBar: AppBar(
        title: Text("Files"),
        backgroundColor: ColorMapper.convert(_course.group),
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
