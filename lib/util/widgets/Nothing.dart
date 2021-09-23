import 'package:flutter/material.dart';

class Nothing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 2,
      child: Text(
        "Nothing here :(",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w200,
        ),
      ),
    );
  }
}
