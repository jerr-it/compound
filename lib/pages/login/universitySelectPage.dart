import 'package:fludip/navdrawer/navDrawer.dart';
import 'package:fludip/net/server.dart';
import 'package:fludip/pages/login/UniversityDropDown.dart';
import 'package:fludip/pages/login/loginPage.dart';
import 'package:fludip/pages/startPage.dart';
import 'package:fludip/provider/user/userProvider.dart';

import 'package:flutter/material.dart';
import 'package:fludip/net/webClient.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class UniversitySelectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("login".tr()),
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
      decoration: BoxDecoration(color: Color.fromARGB(255, 21, 26, 45)),
      child: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "chooseUniversity".tr(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Column(
              children: [
                uDropdown,
                ElevatedButton(
                  child: Text("login".tr()),
                  onPressed: () async {
                    var client = WebClient();
                    client.server = uDropdown.value;

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
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
