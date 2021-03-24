import 'package:fludip/net/webClient.dart';
import 'package:flutter/material.dart';

///Provides data for the courses filed
///Identified by their coureID
///composed of:
/// /:course_id/top_folder
/// /:course_id/folder/folderid
///
///|-:course_id
///  |-id: "f83j2..."
///  |-user_id: "098fj29..."
///  |-parent_id: ""
///  |-range_id: "8j2983jd..."
///  |-range_type: "course"
///  |-folder_type: "RootFolder"
///  |-name: "Test Lehrveranstaltung"
///  |-data_content: []
///  |-description: ""
///  |-mkdate: 1510849315
///  |-chdage: 1510849315
///  |-is_visible: true
///  |-is_readable: true
///  |-is_writable: true
///  |-subfolders[]
///    |-same as above folder, but no subfolder array
///  |-file_refs[]
///    |-id: "e98123e98..."
///    |-file_id: "8921jd98j3d..."
///    |-folder_id: "f83j2..."
///    |-downloads: 2
///    |-description: ""
///    |-content_terms_of_use_id: "FREE_LICENSE"
///    |-user_id: "891je983j..."
///    |-name: "mappe_studip.pdf"
///    |-mkdate: 1607705144
///    |-chdate: 1607705144
///    |-size: 314146
///    |-mime_type: "0"
///    |-storage: "url"
///    |-is_readable: true
///    |-is_downloadable: true
///    |-is_editable: false
///    |-is_writable: false
///    |-url: "/sendfile.php?..."
class FileProvider extends ChangeNotifier {
  Map<String, Map<String, dynamic>> _files;
  final WebClient _client = WebClient();

  bool initialized(String courseID, List<int> subFolderIndices) {
    if (_files == null || _files[courseID] == null) {
      return false;
    }

    Map<String, dynamic> currentFolder = _files[courseID];
    for (int i = 0; i < subFolderIndices.length; i++) {
      currentFolder = currentFolder["subfolders"][subFolderIndices[i]];
    }

    return currentFolder.containsKey("subfolders");
  }

  Map<String, dynamic> getFiles(String courseID, List<int> subFolderIndices) {
    try {
      Map<String, dynamic> currentFolder = _files[courseID];

      for (int i = 0; i < subFolderIndices.length; i++) {
        currentFolder = currentFolder["subfolders"][subFolderIndices[i]];
      }

      return currentFolder;
    } catch (e) {
      return null;
    }
  }

  void update(String courseID, List<int> subFolderIndices) async {
    if (_files == null) {
      _files = new Map<String, Map<String, dynamic>>();

      String route = "/course/$courseID/top_folder";
      var data = await _client.getRoute(route);

      _files[courseID] = data;
    }

    var currentFile = _files[courseID];
    for (int i = 0; i < subFolderIndices.length; i++) {
      //Load the desired folders subfolders, if not done already
      Map<String, dynamic> subFolder = currentFile["subfolders"][subFolderIndices[i]];
      if (!subFolder.containsKey("subfolders")) {
        String subFolderID = subFolder["id"];
        var newSubFolders = await _client.getRoute("/folder/$subFolderID");

        subFolder = newSubFolders;
        currentFile["subfolders"][subFolderIndices[i]] = newSubFolders;
      }

      //Move down to selected folder
      currentFile = subFolder;
    }

    notifyListeners();
  }
}
