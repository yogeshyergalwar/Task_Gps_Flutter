import 'package:flutter/material.dart';

class CustomColors {
  ///--> The below color function is used as background of the app <--///



  ///--> The below color is used in login page and profile page <--///

  Widget gradientColors(Widget widget,BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF312a28),
            Color(0xFF312a28),
          ],
        ),
      ),
      child: widget,
    );
  }


}

///------------------------------------------> The End <------------------------------------------///
