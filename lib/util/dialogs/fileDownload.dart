import 'dart:io' as io;

import 'package:fludip/net/webClient.dart';
import 'package:fludip/provider/course/files/fileModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

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

class FileDownload extends ChangeNotifier {
  File _targetFile;
  WebClient _client = WebClient();

  double _progress = 0;
  double get progress => this._progress;

  FileDownload(File file) : this._targetFile = file;

  void start(Function(bool success, dynamic error) then) async {
    _progress = null;
    notifyListeners();

    String url = _client.server.webAddress + "/api.php/file/" + _targetFile.fileID + "/download";

    Request request = Request("GET", Uri.parse(url));
    request.headers["Cookie"] = _client.sessionCookie;

    StreamedResponse streamedResponse = await Client().send(request);

    int contentLength = streamedResponse.contentLength;

    _progress = 0;
    notifyListeners();

    List<int> bytes = [];
    io.Directory fileLocation = await getApplicationDocumentsDirectory();
    String path = fileLocation.path + "/" + _targetFile.fileID + _targetFile.name;

    streamedResponse.stream.listen((List<int> newBytes) {
      bytes.addAll(newBytes);
      _progress = bytes.length / contentLength;
      notifyListeners();
    }, onDone: () async {
      _progress = 0;
      notifyListeners();

      io.File storedFile = io.File(path);
      await storedFile.writeAsBytes(bytes);
      then(true, null);
    }, onError: (e) {
      then(false, e);
    }, cancelOnError: true);
  }
}
