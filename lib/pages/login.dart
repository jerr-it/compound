import 'package:fludip/provider/user.dart';
import 'package:fludip/provider/user.dart';
import 'package:flutter/material.dart';
import 'package:fludip/net/webclient.dart';
import 'package:fludip/navdrawer/navdrawer.dart';
import 'package:fludip/pages/start.dart';
import 'package:provider/provider.dart';

//TODO option to remain logged in

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
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
  final _formKey = GlobalKey<FormState>();

  int _dropdownIndex;

  @override
  void initState() {
    _dropdownIndex = 0;

    var wclient = WebClient();
    wclient.setServer(Server.instances[0]);
    wclient.authenticate();

    super.initState();
  }

  //TODO better layout
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        alignment: AlignmentDirectional.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            DropdownButton<String>(
              value: Server.instances.elementAt(_dropdownIndex).name(),
              icon: Icon(Icons.arrow_drop_down),
              elevation: 16,
              style: TextStyle(color: Colors.black),
              underline: Container(
                height: 2,
                color: Colors.blue,
              ),
              onChanged: (val) {
                setState(() {
                  _dropdownIndex = Server.instances.indexWhere((Server server){
                    return server.name() == val;
                  });
                  var client = WebClient();
                  client.setServer(Server.instances.elementAt(_dropdownIndex));
                });
              },
              items: Server.instances.map<DropdownMenuItem<String>>((Server server){
                String name = server.name();
                return DropdownMenuItem<String>(
                  value: name,
                  child: Text(name),
                );
              }).toList(),
            ),
            FloatingActionButton(
              child: Icon(Icons.login),
              onPressed: () async {
                var client = WebClient();
                client.authenticate();

                while(!client.isAuthenticated()){}

                var user = await client.getRoute("/users/me");
                Provider.of<User>(context, listen: false).setData(user["data"]);

                Navigator.pop(context);
                Navigator.of(context).push(navRoute(StartPage()));
              },
            )
          ],
        ),
      ),
    );
  }
}
