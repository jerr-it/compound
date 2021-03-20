class StringUtil {
  static String removeHTMLTags(String text) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return text.replaceAll(exp, '');
  }
}
