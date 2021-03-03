import 'package:flutter/material.dart';

class NavDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.portrait, size: 64,),
                Column(
                  children: [
                    Text("Max Mustermann", style: TextStyle(fontSize: 16),),
                    Text("luh-id0", style: TextStyle(fontSize: 16),)
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Punkte: 6666", style: TextStyle(fontWeight: FontWeight.w300),),
                Text("Rang: Halbgott", style: TextStyle(fontWeight: FontWeight.w300),)
              ],
            )
          ],
        ),
      ),
    );
  }
}
