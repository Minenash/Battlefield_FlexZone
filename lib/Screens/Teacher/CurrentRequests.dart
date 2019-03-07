import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:flutter/material.dart';
import 'package:flex_out/User.dart';

class TEA_CurrentRequest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${User.current.first_inital}. ${User.current
                      .lastname}\n${User
                      .current.email}\n${User.typeToString(User.current.type)}",
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.5,
                  style: TextStyle(color: Colors.white),
                ),
                MaterialButton(
                  child: Text("Logout"),
                  onPressed: () {
                    FlutterKeychain.clear();
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                  textTheme: ButtonTextTheme.normal,
                ),
              ]
          )
      ),
    );
  }
}