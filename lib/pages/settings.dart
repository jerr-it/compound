import 'package:compound/provider/themes/themeProvider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  String _themeKey;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    if (this.widget._themeKey == null) {
      this.widget._themeKey = Provider.of<ThemeController>(context, listen: false).key;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "settings".tr(),
          style: GoogleFonts.montserrat(),
        ),
      ),
      body: Container(
        child: ListView(
          children: [
            ListTile(
              title: Text("theme".tr(), style: GoogleFonts.montserrat()),
              trailing: DropdownButton<String>(
                items: ThemeController.presets.keys.map((themeKey) {
                  return DropdownMenuItem(
                    value: themeKey,
                    child: Text(themeKey.tr(), style: GoogleFonts.montserrat()),
                  );
                }).toList(),
                icon: Icon(Icons.arrow_downward),
                value: this.widget._themeKey,
                onChanged: (String newValue) {
                  setState(() {
                    this.widget._themeKey = newValue;
                    Provider.of<ThemeController>(context, listen: false).setTheme(this.widget._themeKey);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
