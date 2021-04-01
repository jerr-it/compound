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

  get name => this._name;
  get description => this._description;

  get fileID => this._fileID;
  get folderID => this._folderID;
  get userID => this._userID;

  get downloadCount => this._downloadCount;
  get termsOfUse => this._termsOfUse;

  get mkdate => this._mkdate;
  get chdate => this._chdate;
  get size => this._size;
  get mimeType => this._mimeType;
  get storage => this._storage;

  get isReadable => this._isReadable;
  get isDownloadable => this._isDownloadable;
  get isEditable => this._isEditable;
  get isWritable => this._isWritable;

  get url => this._url;

  File.fromMap(Map<String, dynamic> data) {
    _name = data["name"];
    _description = data["description"];

    _fileID = data["file_id"];
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
