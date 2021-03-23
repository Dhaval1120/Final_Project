import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xffff512f),Color(0xffdd24760)],//Color(0xff009fff) ,Color(0xffec2f4b)]
        )
      ),
      child: Center(
        child : SpinKitCubeGrid(
          color: Colors.white,
          size: 85,
        )
      ),
    );
  }
}
