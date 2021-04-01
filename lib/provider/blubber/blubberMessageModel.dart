class BlubberMessage {
  String _userName;
  String _content;

  int _mkdate;
  int _chdate;

  String _avatarUrl;
  bool _isMine;

  get userName => this._userName;
  get content => this._content;

  get mkdate => this._mkdate;
  get chdate => this._chdate;

  get avatarUrl => this._avatarUrl;
  get isMine => this._isMine;

  BlubberMessage.fromMap(Map<String, dynamic> data) {
    _userName = data["user_name"];
    _content = data["content"];

    _mkdate = data["mkdate"];
    _chdate = data["chdate"];

    _avatarUrl = data["avatar"];
    _isMine = data["class"] == "mine" ? true : false;
  }
}
