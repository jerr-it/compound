import 'package:flutter/material.dart';
import 'package:fludip/net/webclient.dart';

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

  String usr;
  String pwd;

  //TODO: Add more
  String _dropdownValue;
  List<String> servers = [
    "Leibniz Universität Hannover",
  ];

  String _serverUrl;
  List<String> serverUrls = [
    "https://studip.uni-hannover.de/api.php",
  ];

  @override
  void initState() {
    super.initState();

    _dropdownValue = servers.elementAt(0);
    _serverUrl = serverUrls.elementAt(0);

    var client = WebClient();
    client.setServer(_serverUrl);
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
              value: _dropdownValue,
              icon: Icon(Icons.arrow_drop_down),
              elevation: 16,
              style: TextStyle(color: Colors.black),
              underline: Container(
                height: 2,
                color: Colors.blue,
              ),
              onChanged: (val) {
                setState(() {
                  _dropdownValue = val;
                  _serverUrl = serverUrls.elementAt(servers.indexOf(_dropdownValue));

                  var client = WebClient();
                  client.setServer(_serverUrl);
                });
              },
              items: servers.map<DropdownMenuItem<String>>((val){
                return DropdownMenuItem<String>(
                  value: val,
                  child: Text(val),
                );
              }).toList(),
            ),
            TextFormField(
              maxLengthEnforced: true,
              maxLength: 7,
              decoration: const InputDecoration(
                hintText: "xxx-yyy",
                labelText: "ID",
              ),
              validator: (str) {
                if (str.isEmpty){
                  return "ID may not be empty";
                }else{
                  List<String> parts = str.split("-");
                  if (parts.length != 2 || parts.elementAt(0).length != 3 || parts.elementAt(1).length != 3) {
                    return "ID has to look like \"xxx-yyy\"";
                  }
                }
                usr = str;
                return null;
              },
            ),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
              ),
              validator: (str) {
                pwd = str;
                return null;
              },
            ),
            ElevatedButton(
              onPressed: (){
                if (_formKey.currentState.validate()){
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text("Logging in...")));

                  var client = WebClient();
                  client.setCredentials(usr, pwd);
                  client.get("/discovery").then((value) => print(value));
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
