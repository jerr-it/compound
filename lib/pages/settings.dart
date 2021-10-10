import 'package:compound/provider/themes/themeProvider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

///Adjust some user related settings on this Page
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _themeKey;

  @override
  Widget build(BuildContext context) {
    if (_themeKey == null) {
      _themeKey = Provider.of<ThemeController>(context, listen: false).key;
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
                value: _themeKey,
                onChanged: (String newValue) {
                  setState(() {
                    _themeKey = newValue;
                    Provider.of<ThemeController>(context, listen: false).setTheme(_themeKey);
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
