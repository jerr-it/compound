import 'package:carousel_slider/carousel_slider.dart';
import 'package:fludip/navdrawer/navDrawer.dart';
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

  List<Widget> _buildServerSlides() {
    return Server.instances.map<Widget>((server) {
      return Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: server.color(),
          border: Border.all(color: server.color(), width: 5),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Material(
          color: server.color(),
          child: InkWell(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    server.logoURL(),
                    width: 100,
                    height: 100,
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Text(
                      server.name(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
            onTap: () {
              var client = WebClient();
              client.setServer(server);

              client.authenticate().then((statusCode) async {
                if (statusCode != 200) {
                  //TODO help dialog to clarify error codes
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something went wrong [$statusCode]")));
                  return;
                }

                await Provider.of<UserProvider>(context, listen: false).get();

                Navigator.pushReplacement(context, navRoute(StartPage()));
              });
            },
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color.fromARGB(255, 21, 26, 45)),
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
          CarouselSlider(
            items: _buildServerSlides(),
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 2.0,
              enlargeCenterPage: true,
            ),
          ),
        ],
      ),
    );
  }
}
