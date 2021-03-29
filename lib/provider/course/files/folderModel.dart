import 'package:fludip/provider/course/files/fileModel.dart';

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

    _files = <File>[];
    List<dynamic> fileRefs = data["file_refs"];
    fileRefs.forEach((fileRef) {
      File file = File.fromMap(fileRef);
      _files.add(file);
    });
  }
}
