//Convenience class to be used in grid view below
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GridButton extends StatelessWidget {
  final IconData _icon;
  final String _caption;
  final Color _color;
  final Function _onTap;

  GridButton({@required icon, @required caption, @required color, @required onTap})
      : _icon = icon,
        _caption = caption,
        _color = color,
        _onTap = onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _color,
      child: InkWell(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(_icon),
              Text(
                _caption,
                style: GoogleFonts.montserrat(),
              ),
            ],
          ),
        ),
        onTap: _onTap,
      ),
    );
  }
}
