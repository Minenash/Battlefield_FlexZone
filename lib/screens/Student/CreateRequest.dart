import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flex_out/FlexAssets.dart';
import 'package:flex_out/Lang.dart';
import 'package:flex_out/database.dart';
import 'package:flex_out/structures/Class.dart';

import 'package:flex_out/screens/Student/widgets/ChooseClass.dart';
import 'package:flex_out/screens/Student/CurrentRequests.dart';

class STU_CreateRequest extends StatefulWidget {
  STU_CreateRequest({Key key, this.title}) : super(key: key);
  final String title;

  @override
  STU_CreateRequestState createState() => STU_CreateRequestState();
}

class STU_CreateRequestState extends State<STU_CreateRequest> {

  FlexClass fromClass;
  FlexClass toClass;

  TextEditingController reasonController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void choose_class(FlexClass c, bool index) {
    setState(() {
      if (!index)
        fromClass = c;
      else
        toClass = c;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (MediaQuery.of(context).viewInsets.bottom > 0)
      return Scaffold(
        key: _scaffoldKey,
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            leading: MaterialButton(
                child: FlexIcons.BACK_ARROW,
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            title: Text("Create Flex Request"),
            backgroundColor: FlexColors.BF_PURPLE,
          ),
          backgroundColor: Colors.grey[300],
          body:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(padding: EdgeInsets.only(top: 80)),
              Container (
                  width: 300,
                  child: TextField(
                    controller: reasonController,
                    decoration: InputDecoration(
                        labelText: Lang.trans('reason_field'),
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: FlexColors.BF_PURPLE))),
                  )
              ),
              SizedBox(height: 80),
              RaisedButton(
                  textColor: Colors.white,
                  color: FlexColors.BF_PURPLE,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 26),
                  child: Text("CREATE", style: TextStyle(
                      fontSize: 16
                  )),
                  onPressed: () {},
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0))),
            ],
          )
      );

    return Scaffold(
      key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          leading: MaterialButton(
              child: FlexIcons.BACK_ARROW,
              onPressed: () {
                Navigator.of(context).pop();
              }),
          title: Text("Create Flex Request"),
          backgroundColor: FlexColors.BF_PURPLE,
        ),
        backgroundColor: Colors.grey[300],
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 35),
            ),
            Text("From", style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22
            )),
            SizedBox(height: 20),
            GestureDetector(
              child: Card(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(25.0)),
                child: Container(
                  height: 150,
                  width: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                          fromClass == null ? Icons.help_outline : Icons.class_,
                          size: 50),
                      Text(fromClass == null ? "Select a Class" : fromClass
                          .class_name + "\n(P" + fromClass.period.toString() + ")", style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ), textAlign: TextAlign.center)
                    ],
                  ),

                ),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (c) => STU_ChooseClass(this, false)));
              },
            ),
            SizedBox(height: 20),
            Text("To", style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22
            )),
            SizedBox(height: 20),
            GestureDetector(
              child: Card(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(25.0)),
                child: Container(
                  height: 150,
                  width: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(toClass == null ? Icons.help_outline : Icons.class_,
                          size: 50),
                      Text(toClass == null ? "Select a Class" : toClass
                          .class_name + "\n(P" + toClass.period.toString() + ")", style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                      ), textAlign: TextAlign.center)
                    ],
                  ),
                ),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (c) => STU_ChooseClass(this, true)));
              },
            ),
            SizedBox(height: 20),
            Container (
              width: 300,
                child: TextField(
              controller: reasonController,
              decoration: InputDecoration(
                  labelText: Lang.trans('reason_field'),
                  labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: FlexColors.BF_PURPLE))),
            )
            ),
            SizedBox(height: 80),
            RaisedButton(
                textColor: Colors.white,
                color: FlexColors.BF_PURPLE,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 26),
                child: Text("CREATE", style: TextStyle(
                    fontSize: 16
                )),
                onPressed: () => create(),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0))),
          ],
        )
    );
  }

  void create() {

    if (fromClass == null)
      showError("Pick a class to flex out of.");
    else if (toClass == null)
      showError("Pick a class to flex into.");
    else if (fromClass.id == toClass.id)
      showError("You can't flex in and out of the same class!");
    else {
      Database.create_request(fromClass, toClass, reasonController.toString());

      STU_CurrentRequestState.scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text("Request Created"),
      ));
      Navigator.of(context).pop();
    }
  }

  void showError(String text) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(text),
      backgroundColor: Colors.red,
    ));
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  dispose(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}