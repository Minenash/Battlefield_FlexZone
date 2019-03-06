import 'package:flutter/material.dart';
import 'package:flex_out/User.dart';

class STU_CurrentRequest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Text("${User.current.first_inital}. ${User.current.lastname}\n${User.current.email}\n${User.typeToString(User.current.type)}",
          textAlign: TextAlign.center,
          textScaleFactor: 1.5,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}