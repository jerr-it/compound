// Compound - Mobile StudIP client
// Copyright (C) 2021 Jerrit Gläsker

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
