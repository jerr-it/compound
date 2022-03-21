import 'package:flutter/material.dart';

void showInfo(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      content,
      style: TextStyle(color: Theme.of(context).colorScheme.surface),
    ),
  ));
}
