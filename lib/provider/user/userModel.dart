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

  get userID => this._userID;

  get userName => this._userName;
  get formattedName => this._formattedName;
  get namePrefix => this._namePrefix;
  get nameSuffix => this._nameSuffix;
  get familyName => this._familyName;
  get firstName => this._firstName;

  get phone => this._phone;
  get privateAddress => this._privateAddress;
  get homepage => this._homepage;
  get email => this._email;

  get permissions => this._permissions;

  get avatarUrlOriginal => this._avatarUrlOriginal;
  get avatarUrlSmall => this._avatarUrlSmall;
  get avatarUrlMedium => this._avatarUrlMedium;
  get avatarUrlNormal => this._avatarUrlNormal;

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
