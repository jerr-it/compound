import 'dart:io' as io;

import 'package:compound/net/webClient.dart';
import 'package:compound/provider/course/files/fileModel.dart';
import 'package:compound/util/dialogs/fileDownload.dart';
import 'package:compound/util/str.dart';
import 'package:compound/util/widgets/styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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

class FileInfoRow extends StatelessWidget {
  FileInfoRow(String property, String value)
      : _property = property,
        _value = value;

  final String _property;
  final String _value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              _property,
              style: GoogleFonts.montserrat(),
              overflow: TextOverflow.clip,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              _value,
              style: GoogleFonts.montserrat(fontWeight: FontWeight.w300),
              overflow: TextOverflow.clip,
            ),
          ],
        ),
      ],
    );
  }
}

///Displays information about a file and download/delete options
class FileWidget extends StatefulWidget {
  FileWidget(File file) : this._file = file;

  final File _file;

  @override
  _FileWidgetState createState() => _FileWidgetState();
}

class _FileWidgetState extends State<FileWidget> {
  bool _filePresent = false;
  bool _activeDownload = false;
  String _path;

  @override
  void initState() {
    init();

    super.initState();
  }

  void init() async {
    io.Directory fileLocation = await getApplicationDocumentsDirectory();
    _path = fileLocation.path + "/" + this.widget._file.fileID + this.widget._file.name;
    if (await io.File(_path).exists()) {
      setState(() {
        _filePresent = true;
      });
    }
  }

  List<Widget> _buildControlButtons(FileDownload downloader) {
    List<Widget> buttons = <Widget>[];

    if (this.widget._file.url != null) {
      //Open Button + Close Button
      buttons.add(ElevatedButton(
        onPressed: () async {
          WebClient client = WebClient();
          String base = client.server.webAddress.replaceAll("/studip", "");
          String link = base + this.widget._file.url;

          if (await canLaunch(link)) {
            launch(link);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Can't start browser",
                  style: GoogleFonts.montserrat(),
                ),
              ),
            );
          }
        },
        child: Icon(Icons.open_in_new),
        style: raisedIconButtonStyle(context),
      ));

      buttons.add(ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Icon(Icons.close),
        style: raisedIconButtonStyle(context),
      ));
      return buttons;
    }

    if (_filePresent) {
      //Delete Button + Open Button + Close Button
      buttons.add(ElevatedButton(
        onPressed: () {
          try {
            io.File(_path).delete();
            setState(() {
              _filePresent = false;
              _activeDownload = false;
            });
          } catch (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  error.toString(),
                  style: GoogleFonts.montserrat(),
                ),
              ),
            );
          }
        },
        child: Icon(Icons.delete),
        style: raisedIconButtonStyle(context, color: Colors.red),
      ));

      buttons.add(ElevatedButton(
        onPressed: () {
          OpenFile.open(_path);
        },
        child: Icon(Icons.open_in_new),
        style: raisedIconButtonStyle(context),
      ));

      buttons.add(ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Icon(Icons.close),
        style: raisedIconButtonStyle(context),
      ));
    } else {
      if (_activeDownload) {
        //Progress Indicator + Close Button
        buttons.add(ElevatedButton(
          onPressed: () {},
          child: CircularProgressIndicator(
            value: downloader.progress,
            color: Colors.white,
          ),
          style: raisedIconButtonStyle(context),
        ));

        buttons.add(ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.close),
          style: raisedIconButtonStyle(context),
        ));
      } else {
        //Download Button + Close Button
        buttons.add(ElevatedButton(
          onPressed: () {
            setState(() {
              _activeDownload = true;
              downloader.start((success, error) {
                if (success) {
                  setState(() {
                    _activeDownload = false;
                    _filePresent = true;
                  });
                } else {
                  setState(() {
                    _activeDownload = false;
                    _filePresent = false;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          error.toString(),
                          style: GoogleFonts.montserrat(),
                        ),
                      ),
                    );
                  });
                }
              });
            });
          },
          child: Icon(Icons.download_sharp),
          style: raisedIconButtonStyle(context),
        ));

        buttons.add(ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.close),
          style: raisedIconButtonStyle(context),
        ));
      }
    }

    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FileDownload>(
      create: (context) => FileDownload(this.widget._file),
      child: Consumer<FileDownload>(
        builder: (context, downloader, child) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  this.widget._file.name,
                  style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
                ),
                Divider(),
                FileInfoRow("size".tr(), formatBytes(this.widget._file.size, 2)),
                FileInfoRow("downloads".tr(), this.widget._file.downloadCount.toString()),
                FileInfoRow("created".tr(), StringUtil.fromUnixTime(this.widget._file.mkdate * 1000, "dd.MM.yyyy HH:mm")),
                FileInfoRow("changed".tr(), StringUtil.fromUnixTime(this.widget._file.chdate * 1000, "dd.MM.yyyy HH:mm")),
                FileInfoRow("terms-of-use".tr(), this.widget._file.termsOfUse),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _buildControlButtons(downloader),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class FileDialog {
  static void display(BuildContext context, {@required File file}) {
    AlertDialog dialog = AlertDialog(content: FileWidget(file));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }
}
