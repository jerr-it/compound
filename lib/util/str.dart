import 'package:intl/intl.dart';

class StringUtil {
  static String removeHTMLTags(String text) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return text.replaceAll(exp, '');
  }

  static String fromUnixTime(int timeStamp, String targetFormat) {
    DateFormat formatter = DateFormat(targetFormat);
    DateTime time = new DateTime.fromMillisecondsSinceEpoch(timeStamp);

    return formatter.format(time);
  }
}
