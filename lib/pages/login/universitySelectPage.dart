import 'package:easy_localization/easy_localization.dart';
import 'package:fludip/navdrawer/navDrawer.dart';
import 'package:fludip/net/server.dart';
import 'package:fludip/net/webClient.dart';
import 'package:fludip/pages/login/UniversityDropDown.dart';
import 'package:fludip/pages/login/loginPage.dart';
import 'package:fludip/pages/startPage.dart';
import 'package:fludip/provider/user/userProvider.dart';
import 'package:fludip/util/dialogs/confirmDialog.dart';
import 'package:fludip/util/widgets/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UniversitySelectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "login".tr(),
          style: GoogleFonts.montserrat(),
        ),
      ),
      body: UniversitySelectState(),
    );
  }
}

class UniversitySelectState extends StatefulWidget {
  @override
  _UniversitySelectStateState createState() => _UniversitySelectStateState();
}

class _UniversitySelectStateState extends State<UniversitySelectState> {
  @override
  void initState() {
    var wclient = WebClient();
    wclient.server = Server.instances[0];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UniversityDropdown uDropdown = UniversityDropdown();

    return Container(
      decoration: BoxDecoration(color: Colors.white12),
      child: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                uDropdown,
                ElevatedButton(
                  child: Text(
                    "login".tr(),
                    style: GoogleFonts.montserrat(),
                  ),
                  style: RAISED_TEXT_BUTTON_STYLE(Colors.blue),
                  onPressed: () async {
                    var client = WebClient();
                    client.server = uDropdown.value;

                    if (Uri.parse(client.server.webAddress).scheme != "https") {
                      ConfirmDialog.display(
                        context,
                        title: "warning".tr(),
                        leading: Icon(Icons.warning_sharp),
                        subtitle: "https-info".tr(),
                        firstOption: "confirm".tr(),
                        firstOptionColor: Colors.red,
                        secondOption: "cancel".tr(),
                        onFirstOption: () async {
                          var storage = new FlutterSecureStorage();
                          var username = await storage.read(key: "username");
                          var password = await storage.read(key: "password");

                          if (username == null || password == null) {
                            Navigator.push(context, navRoute(LoginPage()));
                            return;
                          }

                          client.authenticate(username, password).then((statusCode) async {
                            if (statusCode != 200) {
                              //TODO help dialog to clarify error codes
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text("Something went wrong [$statusCode]")));
                              return;
                            }

                            await Provider.of<UserProvider>(context, listen: false).get("self");

                            Navigator.pushReplacement(context, navRoute(StartPage()));
                          });
                        },
                        onSecondOption: () {},
                      );
                    }
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
