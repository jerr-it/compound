import 'package:compound/provider/course/files/fileModel.dart';

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

///Abstracts a StudIP data area folder
class Folder {
  String _name;
  String _description;

  int _mkdate;
  int _chdate;

  String _id;
  String _userID;
  String _parentID;
  String _rangeID;

  String _rangeType;
  String _folderType;

  bool _isVisible;
  bool _isReadable;
  bool _isWritable;

  List<Folder> _subFolders;
  List<File> _files;

  bool _isExpanded;

  String get name => this._name;
  String get description => this._description;

  int get mkdate => this._mkdate;
  int get chdate => this._chdate;

  String get id => this._id;
  String get userID => this._userID;
  String get parentID => this._parentID;
  String get rangeID => this._rangeID;

  String get rangeType => this._rangeType;
  String get folderType => this._folderType;

  bool get isVisible => this._isVisible;
  bool get isReadable => this._isReadable;
  bool get isWritable => this._isWritable;

  List<Folder> get subFolders => this._subFolders;
  List<File> get files => this._files;

  bool get isExpanded => this._isExpanded;

  Folder.fromMap(Map<String, dynamic> data) {
    _name = data["name"];
    _description = data["description"];

    _mkdate = data["mkdate"];
    _chdate = data["chdate"];

    _id = data["id"];
    _userID = data["user_id"];
    _parentID = data["parent_id"];
    _rangeID = data["range_id"];

    _rangeType = data["range_type"];
    _folderType = data["folder_type"];

    _isVisible = data["is_visible"];
    _isReadable = data["is_readable"];
    _isWritable = data["is_writable"];

    if (data.containsKey("subfolders")) {
      List<dynamic> subfolders = data["subfolders"];

      _subFolders = <Folder>[];
      subfolders.forEach((subfolder) {
        Folder subFolder = Folder.fromMap(subfolder);
        _subFolders.add(subFolder);
      });

      _isExpanded = true;
    } else {
      _isExpanded = false;
    }

    if (data.containsKey("file_refs")) {
      _files = <File>[];
      List<dynamic> fileRefs = data["file_refs"];
      fileRefs.forEach((fileRef) {
        File file = File.fromMap(fileRef);
        _files.add(file);
      });
    }
  }
}
