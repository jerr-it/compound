import 'package:easy_localization/easy_localization.dart';
import 'package:fludip/navdrawer/navDrawer.dart';
import 'package:fludip/net/savedServers.dart';
import 'package:fludip/net/webClient.dart';
import 'package:fludip/pages/startPage.dart';
import 'package:fludip/provider/user/userProvider.dart';
import 'package:fludip/util/widgets/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CredentialsPage extends StatelessWidget {
  CredentialsPage(String name) : serverName = name;

  final String serverName;
  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          serverName,
          style: GoogleFonts.montserrat(),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Text(
              "give-server-credentials".tr(),
              style: GoogleFonts.montserrat(),
              textAlign: TextAlign.center,
            ),
            Column(
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: "username".tr(),
                    hintStyle: GoogleFonts.montserrat(color: Colors.black26),
                    icon: Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38, width: 2),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12, width: 2),
                    ),
                  ),
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "password".tr(),
                    hintStyle: GoogleFonts.montserrat(color: Colors.black26),
                    icon: Icon(
                      Icons.password,
                      color: Colors.black,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38, width: 2),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12, width: 2),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    var client = WebClient();
                    int statusCode = await client.authenticate(_usernameController.text, _passwordController.text);
                    if (statusCode == 200) {
                      var storage = new FlutterSecureStorage();
                      storage.write(key: "username", value: _usernameController.text);
                      storage.write(key: "password", value: _passwordController.text);

                      await SavedServers().save();

                      await Provider.of<UserProvider>(context, listen: false).get("self");

                      Navigator.of(context).pushReplacement(navRoute(StartPage()));
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("auth-error".tr(namedArgs: {"errorCode": statusCode.toString()})),
                    ));
                  },
                  child: Icon(Icons.login),
                  style: RAISED_ICON_BUTTON_STYLE(Colors.blue),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
