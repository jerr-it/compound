import 'dart:io' as io;

import 'package:fludip/provider/course/files/fileModel.dart';
import 'package:fludip/util/dialogs/fileDownload.dart';
import 'package:fludip/util/str.dart';
import 'package:fludip/util/widgets/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:open_file/open_file.dart';

class FileInfoRow extends StatelessWidget {
  FileInfoRow(String property, String value)
      : _property = property,
        _value = value;

  String _property;
  String _value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(_property, style: GoogleFonts.montserrat()),
        Text(_value, style: GoogleFonts.montserrat()),
      ],
    );
  }
}

class FileWidget extends StatefulWidget {
  FileWidget(File file) : this._file = file;

  File _file;
  String _path;

  bool _filePresent = false;
  bool _activeDownload = false;

  @override
  _FileWidgetState createState() => _FileWidgetState();
}

class _FileWidgetState extends State<FileWidget> {
  @override
  void initState() {
    init();

    super.initState();
  }

  void init() async {
    io.Directory fileLocation = await getApplicationDocumentsDirectory();
    this.widget._path = fileLocation.path + "/" + this.widget._file.fileID + this.widget._file.name;
    if (await io.File(this.widget._path).exists()) {
      setState(() {
        this.widget._filePresent = true;
      });
    }
  }

  List<Widget> _buildControlButtons(FileDownload downloader) {
    List<Widget> buttons = <Widget>[];

    if (this.widget._filePresent) {
      //Delete Button + Open Button + Close Button
      buttons.add(ElevatedButton(
        onPressed: () {
          try {
            io.File(this.widget._path).delete();
            setState(() {
              this.widget._filePresent = false;
              this.widget._activeDownload = false;
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
        style: RAISED_ICON_BUTTON_STYLE(Colors.red),
      ));

      buttons.add(ElevatedButton(
        onPressed: () {
          OpenFile.open(this.widget._path);
        },
        child: Icon(Icons.open_in_new),
        style: RAISED_ICON_BUTTON_STYLE(Colors.blue),
      ));

      buttons.add(ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Icon(Icons.close),
        style: RAISED_ICON_BUTTON_STYLE(Colors.blue),
      ));
    } else {
      if (this.widget._activeDownload) {
        //Progress Indicator + Close Button
        buttons.add(ElevatedButton(
          onPressed: () {},
          child: CircularProgressIndicator(
            value: downloader.progress,
            color: Colors.white,
          ),
          style: RAISED_ICON_BUTTON_STYLE(Colors.blue),
        ));

        buttons.add(ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.close),
          style: RAISED_ICON_BUTTON_STYLE(Colors.blue),
        ));
      } else {
        //Download Button + Close Button
        buttons.add(ElevatedButton(
          onPressed: () {
            setState(() {
              this.widget._activeDownload = true;
              downloader.start((success, error) {
                if (success) {
                  setState(() {
                    this.widget._activeDownload = false;
                    this.widget._filePresent = true;
                  });
                } else {
                  setState(() {
                    this.widget._activeDownload = false;
                    this.widget._filePresent = false;

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
          style: RAISED_ICON_BUTTON_STYLE(Colors.blue),
        ));

        buttons.add(ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.close),
          style: RAISED_ICON_BUTTON_STYLE(Colors.blue),
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
                FileInfoRow("size".tr(), this.widget._file.size.toString() + " B"),
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
