class News {
  String _topic;
  String _body;
  String _bodyHTML;

  String _userID;
  String _newsID;

  String _commentsUrl;

  int _date;
  int _chdate;
  int _mkdate;
  int _expire;

  bool _allowComments;
  int _commentCount;

  String get topic => this._topic;
  String get body => this._body;
  String get bodyHTML => this._bodyHTML;

  String get userID => this._userID;
  String get newsID => this._newsID;

  String get commentsUrl => this._commentsUrl;

  int get date => this._date;
  int get chdate => this._chdate;
  int get mkdate => this._mkdate;
  int get expire => this._expire;

  bool get allowComments => this._allowComments;
  int get commentCount => this._commentCount;

  News.fromMap(Map<String, dynamic> data) {
    _topic = data["topic"];
    _body = data["body"];
    _bodyHTML = data["body_html"];

    _userID = data["user_id"];
    _newsID = data["news_id"];

    _commentsUrl = data["comments"];

    _date = int.parse(data["date"]) * 1000;
    _chdate = int.parse(data["chdate"]) * 1000;
    _mkdate = int.parse(data["mkdate"]) * 1000;
    _expire = int.parse(data["expire"]) * 1000;

    _allowComments = data["allow_comments"] == "0" ? false : true;
    _commentCount = data["comments_count"];
  }
}
