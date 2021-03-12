import 'package:fludip/net/fakeclient.dart';
import 'package:flutter/material.dart';
import 'package:fludip/net/webclient.dart';
import 'package:fludip/navdrawer/navdrawer.dart';
import 'package:fludip/pages/start.dart';

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

  String _username;
  String _passphrase;

  int _dropdownIndex;

  @override
  void initState() {
    _dropdownIndex = 0;

    var client = FakeClient();
    client.init("assets/data/fakedata.json");
    client.setServer(Server.instances.elementAt(_dropdownIndex));


    var wclient = WebClient();
    wclient.setServer(Server.instances[0]);
    wclient.authorize();

    wclient.getRoute("/users/me").then((data) {
      print(data);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
        child: Column(
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
                  var client = FakeClient();
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
            TextFormField(
              initialValue: "exa-mpl", //TODO remove in the future
              maxLengthEnforced: true,
              maxLength: 7,
              decoration: const InputDecoration(
                hintText: "xxx-yyy",
                labelText: "ID",
              ),
              validator: (str) {
                //TODO automatically add '-' while typing
                if (str.isEmpty){
                  return "ID may not be empty";
                }else{
                  List<String> parts = str.split("-");
                  if (parts.length != 2 || parts.elementAt(0).length != 3 || parts.elementAt(1).length != 3) {
                    return "ID has to look like \"xxx-yyy\"";
                  }
                }
                _username = str;
                return null;
              },
            ),
            TextFormField(
              initialValue: "abc", //TODO remove in the future
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
              ),
              validator: (str) {
                _passphrase = str;
                return null;
              },
            ),
            ElevatedButton(
              onPressed: (){
                if (_formKey.currentState.validate()){
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text("Logging in...")));

                  var client = FakeClient();
                  client.login(_username, _passphrase).then((success){
                    if (success) {
                      client.doRoute("/courses").then((str) {
                        if (str == null){
                          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Something went wrong...")));
                        }

                        //Go to start page
                        Navigator.pop(context);
                        Navigator.of(context).push(navRoute(StartPage()));
                      });
                    }else{
                      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Invalid username or password")));
                    }
                  });
                }
              },
              child: Text("Submit"),
            )
          ],
        ),
      ),
    );
  }
}
