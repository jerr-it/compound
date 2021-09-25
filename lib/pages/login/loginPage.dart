import 'package:fludip/navdrawer/navDrawer.dart';
import 'package:fludip/pages/login/UniversityDropDown.dart';
import 'package:fludip/pages/startPage.dart';
import 'package:fludip/provider/user/userProvider.dart';

import 'package:flutter/material.dart';
import 'package:fludip/net/webClient.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("login".tr()),
      ),
      body: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  void initState() {
    var wclient = WebClient();
    wclient.setServer(Server.instances[0]);

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
                  onPressed: () {
                    var client = WebClient();
                    client.setServer(uDropdown.value);

                    client.authenticate().then((statusCode) async {
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
