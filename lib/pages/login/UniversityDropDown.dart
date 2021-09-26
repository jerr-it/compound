import 'package:fludip/net/server.dart';
import 'package:flutter/material.dart';

class UniversityDropdown extends StatefulWidget {
  UniversityDropdown({Key key}) : super(key: key);

  Server value = Server.instances.first;

  @override
  _UniversityDropdownState createState() => _UniversityDropdownState();
}

class _UniversityDropdownState extends State<UniversityDropdown> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.network(
          this.widget.value.logoURL,
          width: MediaQuery.of(context).size.width / 3,
        ),
        DropdownButton<Server>(
          items: Server.instances.map((Server server) {
            return DropdownMenuItem<Server>(
                value: server,
                child: Text(
                  server.name,
                  style: TextStyle(color: Colors.black),
                ));
          }).toList(),
          value: this.widget.value,
          icon: Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.black),
          underline: Container(
            height: 2,
            color: Colors.black,
          ),
          onChanged: (Server newValue) {
            setState(() {
              this.widget.value = newValue;
            });
          },
        )
      ],
    );
  }
}
