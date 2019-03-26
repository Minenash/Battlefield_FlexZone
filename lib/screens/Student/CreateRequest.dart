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
    return Scaffold(
      key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          leading: MaterialButton(
              child: FlexIcons.BACK_ARROW,
              onPressed: () {
                Navigator.of(context).pop();
              }),
          title: Text(Lang.trans('create_request_title')),
          backgroundColor: FlexColors.BF_PURPLE,
        ),
        backgroundColor: Colors.grey[300],
        body: Column(
          children: <Widget>[
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                from(),
                SizedBox(width: 20),
                to(),
              ],
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
            SizedBox(height: 50),
            RaisedButton(
                textColor: Colors.white,
                color: FlexColors.BF_PURPLE,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 26),
                child: Text(Lang.trans('create_button'), style: TextStyle(
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
      showError(Lang.trans('no_from_class'));
    else if (toClass == null)
      showError(Lang.trans('no_to_class'));
    else if (fromClass.id == toClass.id)
      showError(Lang.trans('from_is_to_class'));
    else {
      Database.create_request(fromClass, toClass, reasonController.text);

      STU_CurrentRequestState.scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(Lang.trans('request_sent')),
      ));
      Navigator.of(context).pop();
    }
  }

  Widget from() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(Lang.trans('from'), style: TextStyle(
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
                  Text(fromClass == null ? Lang.trans('select_class') : fromClass
                      .class_name + "\n(" + Lang.trans('period_prefix') + fromClass.period.toString() + ")", style: TextStyle(
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
      ],
    );
  }

  Widget to() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(Lang.trans('to'), style: TextStyle(
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
                      toClass == null ? Icons.help_outline : Icons.class_,
                      size: 50),
                  Text(toClass == null ? Lang.trans('select_class') : toClass
                      .class_name + "\n(" + Lang.trans('period_prefix') + toClass.period.toString() + ")", style: TextStyle(
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
      ],
    );
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