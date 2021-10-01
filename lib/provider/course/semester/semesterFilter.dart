enum FilterType {
  CURRENT,
  CURRENT_NEXT,
  LAST_CURRENT,
  LAST_CURRENT_NEXT,
  ALL,
  SPECIFIC,
}

class SemesterFilter {
  FilterType _type;
  String _id; //Only used when type == SPECIFIC

  FilterType get type => _type;
  String get id => _id;

  SemesterFilter(FilterType type, String id)
      : _type = type,
        _id = id;
}
