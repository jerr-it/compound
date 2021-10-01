import 'package:fludip/net/server.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UniversityDropdown extends StatefulWidget {
  UniversityDropdown({Key key}) : super(key: key);

  Server value = Server.instances.first;

  @override
  _UniversityDropdownState createState() => _UniversityDropdownState();
}

class _UniversityDropdownState extends State<UniversityDropdown> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);

    _controller.forward();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FadeTransition(
          opacity: _animation,
          child: Image.network(
            this.widget.value.logoURL,
            width: MediaQuery.of(context).size.width / 3,
            height: MediaQuery.of(context).size.height / 4,
          ),
        ),
        DropdownButton<Server>(
          items: Server.instances.map((Server server) {
            return DropdownMenuItem<Server>(
                value: server,
                child: Text(
                  server.name,
                  style: GoogleFonts.montserrat(color: Colors.black),
                ));
          }).toList(),
          value: this.widget.value,
          icon: Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: GoogleFonts.montserrat(),
          underline: Container(
            height: 2,
            color: Colors.black,
          ),
          onChanged: (Server newValue) {
            setState(() {
              this.widget.value = newValue;
              _controller.reset();
              _controller.forward();
            });
          },
        )
      ],
    );
  }
}
