import 'package:fludip/navdrawer/navDrawer.dart';
import 'package:fludip/net/webClient.dart';
import 'package:fludip/provider/course/files/fileModel.dart';
import 'package:fludip/provider/course/files/fileProvider.dart';
import 'package:fludip/provider/course/files/folderModel.dart';
import 'package:fludip/util/commonWidgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilesTab extends StatefulWidget {
  String _courseID;
  Color _color;
  List<int> _subFolderPath;

  Folder _currentFolder;

  FilesTab({@required courseID, @required color, @required path})
      : _courseID = courseID,
        _color = color,
        _subFolderPath = path;

  @override
  _FilesTabState createState() => _FilesTabState();
}

class _FilesTabState extends State<FilesTab> {
  List<Widget> _buildFileList() {
    List<Widget> widgets = <Widget>[];
    if (widget._currentFolder == null) {
      return widgets;
    }

    List<Folder> subfolders = widget._currentFolder.subFolders;
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
        onTap: () {
          List<int> subPath = <int>[];
          subPath.addAll(widget._subFolderPath);
          subPath.add(i);

          if (!Provider.of<FileProvider>(context, listen: false).initialized(widget._courseID, subPath)) {
            Provider.of<FileProvider>(context, listen: false).update(widget._courseID, subPath);
          }

          Navigator.push(
            context,
            navRoute(FilesTab(
              courseID: widget._courseID,
              color: widget._color,
              path: subPath,
            )),
          );
        },
      ));
    }

    List<File> fileRefs = widget._currentFolder.files;
    fileRefs.forEach((fileRef) {
      widgets.add(ListTile(
        leading: Icon(Icons.file_copy),
        title: Text(fileRef.name),
        onTap: () {
          var client = WebClient();
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
    widget._currentFolder = Provider.of<FileProvider>(context).getFolder(widget._courseID, widget._subFolderPath);

    return Scaffold(
      appBar: AppBar(
        title: Text("Files"),
        backgroundColor: widget._color,
      ),
      body: RefreshIndicator(
        child: Container(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            children: _buildFileList(),
          ),
        ),
        onRefresh: () async {
          Provider.of<FileProvider>(context, listen: false).update(widget._courseID, widget._subFolderPath);
          return Future<void>.value(null);
        },
      ),
    );
  }
}
