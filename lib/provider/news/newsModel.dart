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

  get topic => this._topic;
  get body => this._body;
  get bodyHTML => this._bodyHTML;

  get userID => this._userID;
  get newsID => this._newsID;

  get commentsUrl => this._commentsUrl;

  get date => this._date;
  get chdate => this._chdate;
  get mkdate => this._mkdate;
  get expire => this._expire;

  get allowComments => this._allowComments;
  get commentCount => this._commentCount;

  News.fromMap(Map<String, dynamic> data) {
    _topic = data["topic"];
    _body = data["body"];
    _bodyHTML = data["body_html"];

    _userID = data["user_id"];
    _newsID = data["news_id"];

    _commentsUrl = data["comments"];

    _date = data["date"];
    _chdate = data["chdate"];
    _mkdate = data["mkdate"];
    _expire = data["expire"];

    _allowComments = data["allow_comments"];
    _commentCount = data["comments_count"];
  }
}
