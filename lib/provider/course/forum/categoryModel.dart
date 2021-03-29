import 'package:fludip/provider/course/forum/areaModel.dart';

class ForumCategory {
  String _name;
  String _categoryID;

  List<ForumArea> _areas;

  String get name => this._name;
  String get categoryID => this._categoryID;

  List<ForumArea> get areas => this._areas;
  set areas(value) => this._areas = value;

  ForumCategory.fromMap(Map<String, dynamic> data) {
    _name = data["entry_name"];
    _categoryID = data["category_id"];
  }
}
