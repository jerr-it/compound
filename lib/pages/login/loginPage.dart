import 'package:fludip/navdrawer/navDrawer.dart';
import 'package:fludip/net/webClient.dart';
import 'package:fludip/pages/startPage.dart';
import 'package:fludip/provider/user/userProvider.dart';
import 'package:fludip/util/widgets/styles.dart';
import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var usernameController = TextEditingController();
    var passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "login".tr(),
          style: GoogleFonts.montserrat(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white12),
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        hintText: "Username",
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
                      style: GoogleFonts.montserrat(),
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: GoogleFonts.montserrat(color: Colors.black26),
                        icon: Icon(
                          Icons.password_sharp,
                          color: Colors.black,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black38, width: 2),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12, width: 2),
                        ),
                      ),
                      style: GoogleFonts.montserrat(),
                    ),
                    ElevatedButton(
                      child: Text("login".tr(), style: GoogleFonts.montserrat()),
                      style: RAISED_TEXT_BUTTON_STYLE(Colors.blue),
                      onPressed: () async {
                        var client = WebClient();

                        client.authenticate(usernameController.text, passwordController.text).then((statusCode) async {
                          if (statusCode != 200) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text("Something went wrong [$statusCode]")));
                            return;
                          }

                          var storage = new FlutterSecureStorage();
                          storage.write(key: "username", value: usernameController.text);
                          storage.write(key: "password", value: passwordController.text);

                          await Provider.of<UserProvider>(context, listen: false).get("self");

                          Navigator.pushReplacement(context, navRoute(StartPage()));
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
