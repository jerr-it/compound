import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

final Map DIRECT_MATCH = <String, Icon>{
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
final Function MIME_TO_ICON = (String mime) {
  DIRECT_MATCH.forEach((mime_type, icon) {
    if (mime == mime_type) {
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
