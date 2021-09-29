import 'dart:io' as io;

import 'package:fludip/net/webClient.dart';
import 'package:fludip/provider/course/files/fileModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

class FileDownload extends ChangeNotifier {
  File _targetFile;
  WebClient _client = WebClient();

  double _progress = 0;
  double get progress => this._progress;

  FileDownload(File file) : this._targetFile = file;

  Future<bool> start(Function(bool success, dynamic error) then) async {
    _progress = null;
    notifyListeners();

    String url = _client.server.webAddress + "/sendfile.php?file_id=" + _targetFile.fileID;
    Request request = Request("GET", Uri.parse(url));
    request.headers["Authorization"] = "Basic " + _client.credentials.encodeB64();
    StreamedResponse streamedResponse = await Client().send(request);

    int contentLength = streamedResponse.contentLength;

    _progress = 0;
    notifyListeners();

    List<int> bytes = [];
    io.Directory fileLocation = await getApplicationDocumentsDirectory();
    String path = fileLocation.path + "/" + _targetFile.fileID + _targetFile.name;
    io.File storedFile = io.File(path);

    streamedResponse.stream.listen((List<int> newBytes) {
      bytes.addAll(newBytes);
      _progress = bytes.length / contentLength;
      notifyListeners();
    }, onDone: () async {
      _progress = 0;
      notifyListeners();
      await storedFile.writeAsBytes(bytes);
      then(true, null);
    }, onError: (e) {
      then(false, e);
    }, cancelOnError: true);
  }
}
