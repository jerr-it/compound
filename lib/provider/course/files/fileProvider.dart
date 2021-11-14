import 'dart:convert';

import 'package:compound/net/webClient.dart';
import 'package:compound/provider/course/files/fileHtmlParser.dart';
import 'package:compound/provider/course/files/fileModel.dart';
import 'package:compound/provider/course/files/folderModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

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

///Provides data for the courses filed
///Identified by their coureID
class FileProvider extends ChangeNotifier {
  Map<String, Folder> _fileTree;
  final WebClient _client = WebClient();

  List<File> newFiles = [];

  ///Checks if a courses filetree is initialized.
  ///[subFolderIndices] is a list of indices of the courses subfolders used to traverse the tree
  bool initialized(String courseID, List<int> subFolderIndices) {
    if (_fileTree == null || _fileTree[courseID] == null) {
      return false;
    }

    Folder current = _fileTree[courseID];
    for (int i = 0; i < subFolderIndices.length; i++) {
      current = current.subFolders[subFolderIndices[i]];
    }
    return current.isExpanded;
  }

  ///Retrieve a folder from the tree.
  Future<Folder> get(String courseID, List<int> subFolderIndices, bool hasNew) {
    if (!initialized(courseID, subFolderIndices)) {
      return forceUpdate(courseID, subFolderIndices, hasNew);
    }

    Folder current = _fileTree[courseID];
    for (int i = 0; i < subFolderIndices.length; i++) {
      current = current.subFolders[subFolderIndices[i]];
    }
    return Future<Folder>.value(current);
  }

  //Force an update on a folder in the tree
  Future<Folder> forceUpdate(String courseID, List<int> subFolderIndices, bool hasNew) async {
    _fileTree ??= <String, Folder>{};

    Response res = await _client.httpGet("/course/$courseID/top_folder", APIType.REST);
    Folder topFolder = Folder.fromMap(jsonDecode(res.body));
    _fileTree[courseID] = topFolder;

    Folder current = _fileTree[courseID];
    for (int i = 0; i < subFolderIndices.length; i++) {
      Folder subFolder = current.subFolders[subFolderIndices[i]];

      if (!subFolder.isExpanded) {
        String folderID = subFolder.id;
        String route = "/folder/$folderID";

        Response res = await _client.httpGet(route, APIType.REST);
        Folder expandedSubfolder = Folder.fromMap(jsonDecode(res.body));

        current.subFolders[subFolderIndices[i]] = expandedSubfolder;
      }

      current = current.subFolders[subFolderIndices[i]];
    }

    //No api route to get new files
    //So web-scraping it is
    if (hasNew) {
      Response response = await _client.internal.get(
        Uri.parse(_client.server.webAddress + "/seminar_main.php").replace(queryParameters: {
          "auswahl": courseID,
          "redirect_to": _client.server.webAddress + "/dispatch.php/course/files/flat&select=new",
        }),
        headers: {
          "Cookie": _client.sessionCookie,
        },
      );

      List<String> newFileIDs = FileHtmlParser.scan(response.body);
      newFiles = await _getFiles(newFileIDs);
    }

    notifyListeners();
    return Future<Folder>.value(current);
  }

  ///Retrieves file information about all the given file ids
  Future<List<File>> _getFiles(List<String> ids) async {
    List<File> files = [];

    await Future.forEach(ids, (String id) async {
      String route = "/file/$id";
      Response res = await _client.httpGet(route, APIType.REST);
      File file = File.fromMap(jsonDecode(res.body));
      files.add(file);
    });

    return Future<List<File>>.value(files);
  }

  void resetCache() {
    _fileTree = null;
  }
}
