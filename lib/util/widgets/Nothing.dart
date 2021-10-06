import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Nothing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 2,
      child: Text(
        "nothing_here".tr(),
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w200,
        ),
      ),
    );
  }
}
