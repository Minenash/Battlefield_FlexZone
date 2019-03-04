import 'package:flutter/material.dart';
import 'package:flex_out/Screens/Login.dart';
import 'package:flex_out/Screens/Student/CurrentRequests.dart';
import 'package:flex_out/Screens/Teacher/CurrentRequests.dart';
import 'package:flex_out/Screens/Admin/CurrentRequests.dart';

void main() => runApp(new FlexZoneApp());

class FlexZoneApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => new LoginScreen(),
        '/stu_cr': (BuildContext context) => new STU_CurrentRequest(),
        '/tea_cr': (BuildContext context) => new TEA_CurrentRequest(),
        '/adm_cr':   (BuildContext context) => new ADM_CurrentRequest(),
      },
      home: new LoginScreen(),
    );
  }
}