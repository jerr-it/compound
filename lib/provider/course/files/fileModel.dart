import 'dart:math';

String formatBytes(int bytes, int decimals) {
  if (bytes <= 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  var i = (log(bytes) / log(1024)).floor();
  return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + ' ' + suffixes[i];
}

class File {
  String _name;
  String _description;

  String _fileID;
  String _folderID;
  String _userID;

  int _downloadCount;
  String _termsOfUse;

  int _mkdate;
  int _chdate;
  int _size;
  String _mimeType;
  String _storage;

  bool _isReadable;
  bool _isDownloadable;
  bool _isEditable;
  bool _isWritable;

  String _url;

  String get name => this._name;
  String get description => this._description;

  String get fileID => this._fileID;
  String get folderID => this._folderID;
  String get userID => this._userID;

  int get downloadCount => this._downloadCount;
  String get termsOfUse => this._termsOfUse;

  int get mkdate => this._mkdate;
  int get chdate => this._chdate;
  int get size => this._size;
  String get mimeType => this._mimeType;
  String get storage => this._storage;

  bool get isReadable => this._isReadable;
  bool get isDownloadable => this._isDownloadable;
  bool get isEditable => this._isEditable;
  bool get isWritable => this._isWritable;

  String get url => this._url;

  File.fromMap(Map<String, dynamic> data) {
    _name = data["name"];
    _description = data["description"];

    _fileID = data["id"];
    _folderID = data["folder_id"];
    _userID = data["user_id"];

    _downloadCount = data["downloads"];
    _termsOfUse = data["content_terms_of_use_id"];

    _mkdate = data["mkdate"];
    _chdate = data["chdate"];
    _size = data["size"];
    _mimeType = data["mime_type"];
    _storage = data["storage"];

    _isReadable = data["is_readable"];
    _isDownloadable = data["is_downloadable"];
    _isEditable = data["is_editable"];
    _isWritable = data["is_writable"];

    _url = data["url"];
  }
}
