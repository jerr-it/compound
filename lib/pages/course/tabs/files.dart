import 'package:fludip/navdrawer/navDrawer.dart';
import 'package:fludip/provider/course/fileProvider.dart';
import 'package:fludip/util/commonWidgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilesTab extends StatefulWidget {
  String _courseID;
  Color _color;
  List<int> _subFolderPath;

  Map<String, dynamic> _files;

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
    if (widget._files == null) {
      return widgets;
    }

    List<dynamic> subfolders = widget._files["subfolders"];
    if (subfolders == null) {
      return widgets;
    }

    for (int i = 0; i < subfolders.length; i++) {
      Map<String, dynamic> subfolder = subfolders[i];

      if (!subfolder.containsKey("name")) {
        continue;
      }

      widgets.add(ListTile(
        leading: Icon(Icons.folder),
        title: Text(subfolder["name"]),
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

    List<dynamic> fileRefs = widget._files["file_refs"];
    fileRefs.forEach((fileRef) {
      widgets.add(ListTile(
        leading: Icon(Icons.file_copy),
        title: Text(fileRef["name"]),
      ));
    });

    if (widgets.isEmpty) {
      widgets.add(CommonWidgets.nothing());
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    widget._files = Provider.of<FileProvider>(context).getFiles(widget._courseID, widget._subFolderPath);

    return Scaffold(
      appBar: AppBar(
        title: Text("Files"),
        backgroundColor: widget._color,
      ),
      body: RefreshIndicator(
        child: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
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
