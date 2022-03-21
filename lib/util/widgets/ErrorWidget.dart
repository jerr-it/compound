import 'package:flutter/material.dart';

class ErrorWidget extends StatelessWidget {
  ErrorWidget(String err) : errText = err;

  final String errText;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(Icons.error),
      Text(errText),
    ]);
  }
}
