import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:fludip/net/webClient.dart';
import 'package:fludip/provider/course/files/folderModel.dart';

///Provides data for the courses filed
///Identified by their coureID
class FileProvider extends ChangeNotifier {
  Map<String, Folder> _fileTree;
  final WebClient _client = WebClient();

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

  Future<Folder> get(String courseID, List<int> subFolderIndices) {
    if (!initialized(courseID, subFolderIndices)) {
      return forceUpdate(courseID, subFolderIndices);
    }

    Folder current = _fileTree[courseID];
    for (int i = 0; i < subFolderIndices.length; i++) {
      current = current.subFolders[subFolderIndices[i]];
    }
    return Future<Folder>.value(current);
  }

  Future<Folder> forceUpdate(String courseID, List<int> subFolderIndices) async {
    _fileTree ??= <String, Folder>{};

    if (!_fileTree.containsKey(courseID)) {
      Response res = await _client.httpGet("/course/$courseID/top_folder", APIType.REST);

      Folder topFolder = Folder.fromMap(jsonDecode(res.body));

      _fileTree[courseID] = topFolder;
    }

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

    notifyListeners();
    return Future<Folder>.value(current);
  }
}
