import 'package:flutter/material.dart';

import 'package:flex_out/database.dart';
import 'package:flex_out/structures/User.dart';

import 'package:flex_out/screens/Login.dart';
import 'package:flex_out/screens/Student/CurrentRequests.dart';
import 'package:flex_out/screens/Student/Archive.dart';
import 'package:flex_out/screens/Student/Classes.dart';
import 'package:flex_out/screens/Student/CreateRequest.dart';
import 'package:flex_out/screens/Student/JoinClass.dart';
import 'package:flex_out/screens/Teacher/CurrentRequests.dart';


void main() => runApp(new FlexZoneApp());

class FlexZoneApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder(
        future: Database.loadUser(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return snapshot.hasData ? MaterialApp(
            title: "Flex Zone",
            debugShowCheckedModeBanner: false,
            routes: <String, WidgetBuilder>{
              '/login': (BuildContext context) => new LoginScreen(),

              '/stu/current': (BuildContext context) => new STU_CurrentRequest(),
              '/stu/archive': (BuildContext context) => new STU_Archive(),
              '/stu/create': (BuildContext context) => new STU_CreateRequest(),
              '/stu/classes': (BuildContext context) => new STU_Classes(),
              '/stu/joinclass/teacher': (BuildContext context) => new STU_JoinClass_Teacher(),

              '/tea/current': (BuildContext context) => new TEA_CurrentRequest(),
            },
            home: User.current == null ? new LoginScreen() :
            User.current.type == UserType.STUDENT ? new STU_CurrentRequest() :
                                                    new TEA_CurrentRequest(),
          ) : _loading;
        });
  }

  Widget _loading = MaterialApp(
      home: Scaffold(
        body: new Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text("Loading")
              ],
            )
        ),
      )
  );
}