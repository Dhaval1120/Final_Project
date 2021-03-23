import 'package:flutter/material.dart';

class Background extends StatelessWidget {

  final color1 = const Color(0xff29323c);
  final color2 = const Color(0xff485563);
  final color3 = const Color(0xffb7f8db);
  final color4 = const Color(0xff50a7c2);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xffff512f),Color(0xffdd2476)],//Color(0xff009fff) ,Color(0xffec2f4b)],

            //begin : Alignment.center,
            //end : Alignment.bottomRight
        ),
      ),
    );
  }
}
