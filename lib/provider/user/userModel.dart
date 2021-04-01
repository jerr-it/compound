class User {
  String _userID;

  String _userName;
  String _formattedName;
  String _namePrefix;
  String _nameSuffix;
  String _familyName;
  String _firstName;

  String _phone;
  String _privateAddress;
  String _homepage;
  String _email;

  String _permissions;

  String _avatarUrlOriginal;
  String _avatarUrlSmall;
  String _avatarUrlMedium;
  String _avatarUrlNormal;

  String get userID => this._userID;

  String get userName => this._userName;
  String get formattedName => this._formattedName;
  String get namePrefix => this._namePrefix;
  String get nameSuffix => this._nameSuffix;
  String get familyName => this._familyName;
  String get firstName => this._firstName;

  String get phone => this._phone;
  String get privateAddress => this._privateAddress;
  String get homepage => this._homepage;
  String get email => this._email;

  String get permissions => this._permissions;

  String get avatarUrlOriginal => this._avatarUrlOriginal;
  String get avatarUrlSmall => this._avatarUrlSmall;
  String get avatarUrlMedium => this._avatarUrlMedium;
  String get avatarUrlNormal => this._avatarUrlNormal;

  User.fromMap(Map<String, dynamic> data) {
    _userID = data["user_id"];

    _userName = data["username"];
    _formattedName = data["name"]["formatted"];
    _namePrefix = data["name"]["prefix"];
    _nameSuffix = data["name"]["suffix"];
    _familyName = data["name"]["family"];
    _firstName = data["name"]["given"];

    _phone = data["phone"];
    _privateAddress = data["privadr"];
    _homepage = data["homepage"];
    _email = data["email"];

    _permissions = data["perms"];

    _avatarUrlOriginal = data["avatar_original"];
    _avatarUrlSmall = data["avatar_small"];
    _avatarUrlMedium = data["avatar_medium"];
    _avatarUrlNormal = data["avatar_normal"];
  }
}
