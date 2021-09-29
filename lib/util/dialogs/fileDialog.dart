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
  bool _isDownloading = false;
  bool _failed = false;
  bool _done = false;
  dynamic _error;

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
        this.widget._done = true;
        this.widget._failed = false;
      });
    }
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
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: this.widget._isDownloading ? 1.0 : 0.0,
                      child: LinearProgressIndicator(
                        value: downloader.progress,
                        color: Colors.blue,
                      ),
                    ),
                    Opacity(
                      opacity: this.widget._failed ? 1.0 : 0.0,
                      child: Column(
                        children: [
                          Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                          Text(this.widget._error.toString(), style: GoogleFonts.montserrat()),
                        ],
                      ),
                    ),
                    Opacity(
                      opacity: this.widget._done && !this.widget._failed ? 1.0 : 0.0,
                      child: Icon(
                        Icons.download_done,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
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
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        //Dont download a file we already have
                        if (this.widget._done) {
                          //Open file using default program
                          OpenFile.open(this.widget._path);
                          return;
                        }

                        setState(() {
                          this.widget._isDownloading = true;
                        });

                        downloader.start((bool success, dynamic error) {
                          if (success) {
                            setState(() {
                              this.widget._failed = true;
                              this.widget._error = error;
                            });
                          }
                          setState(() {
                            this.widget._done = true;
                          });
                        });
                      },
                      style: RAISED_BUTTON_STYLE(Colors.blue),
                      child: Text(
                        this.widget._done ? "open".tr() : "download".tr(),
                        style: GoogleFonts.montserrat(),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: RAISED_BUTTON_STYLE(Colors.blue),
                      child: Text("close".tr(), style: GoogleFonts.montserrat()),
                    ),
                  ],
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
