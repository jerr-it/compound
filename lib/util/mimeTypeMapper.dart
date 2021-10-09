import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

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

final Map directMatch = <String, Icon>{
  "application/vnd.ms-excel": Icon(FontAwesome5.file_excel),
  "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet": Icon(FontAwesome5.file_excel),
  "application/msword": Icon(FontAwesome5.file_word),
  "application/vnd.openxmlformats-officedocument.wordprocessingml.document": Icon(FontAwesome5.file_word),
  "application/vnd.ms-powerpoint": Icon(FontAwesome5.file_powerpoint),
  "application/vnd.openxmlformats-officedocument.presentationml.presentation": Icon(FontAwesome5.file_powerpoint),
  "application/pdf": Icon(FontAwesome5.file_pdf),
  "application/zip": Icon(FontAwesome5.file_archive),
  "application/x-7z-compressed": Icon(FontAwesome5.file_archive),
  "application/x-freearc": Icon(FontAwesome5.file_archive),
  "application/x-bzip": Icon(FontAwesome5.file_archive),
  "application/x-bzip2": Icon(FontAwesome5.file_archive),
  "application/gzip": Icon(FontAwesome5.file_archive),
  "application/java-archive": Icon(FontAwesome5.file_archive),
  "application/vnd.rar": Icon(FontAwesome5.file_archive),
  "application/x-tar": Icon(FontAwesome5.file_archive),
};

//https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types
final Function mimeToIcon = (String mime) {
  directMatch.forEach((mimeType, icon) {
    if (mime == mimeType) {
      return icon;
    }
  });

  if (mime.startsWith("audio")) {
    return Icon(FontAwesome5.file_audio);
  }

  if (mime.startsWith("image")) {
    return Icon(FontAwesome5.file_image);
  }

  if (mime.startsWith("video")) {
    return Icon(FontAwesome5.file_video);
  }

  if (mime.startsWith("text")) {
    return Icon(FontAwesome.file_text);
  }

  return Icon(Icons.file_copy);
};
