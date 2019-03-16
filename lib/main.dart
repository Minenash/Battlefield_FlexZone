import 'package:flutter/material.dart';
import 'package:flex_out/Screens/Login.dart';
import 'package:flex_out/Screens/Student/CurrentRequests.dart';
import 'package:flex_out/Screens/Student/Archive.dart';
import 'package:flex_out/Screens/Student/Classes.dart';
import 'package:flex_out/Screens/Student/CreateRequest.dart';
import 'package:flex_out/Screens/Student/JoinClass.dart';
import 'package:flex_out/Screens/Teacher/CurrentRequests.dart';
import 'package:flex_out/Screens/Admin/CurrentRequests.dart';
import 'package:flex_out/database.dart';
import 'package:flex_out/User.dart';

void main() => runApp(new FlexZoneApp());

class FlexZoneApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Database.loadUser(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return snapshot.hasData ? MaterialApp(
            debugShowCheckedModeBanner: false,
            routes: <String, WidgetBuilder>{
              '/login': (BuildContext context) => new LoginScreen(),

              '/stu/current': (BuildContext context) => new STU_CurrentRequest(),
              '/stu/archive': (BuildContext context) => new STU_Archive(),
              '/stu/create': (BuildContext context) => new STU_CreateRequest(),
              '/stu/classes': (BuildContext context) => new STU_Classes(),
              '/stu/joinclass': (BuildContext context) => new STU_JoinClass(),

              '/tea/current': (BuildContext context) => new TEA_CurrentRequest(),
              '/adm/current': (BuildContext context) => new ADM_CurrentRequest(),
            },
            home: User.current == null ? new LoginScreen() :
            User.current.type == UserType.STUDENT ? new STU_CurrentRequest() :
            User.current.type == UserType.TEACHER ? new TEA_CurrentRequest() :
            new ADM_CurrentRequest(),
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