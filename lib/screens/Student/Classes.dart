import 'package:flutter/material.dart';

import 'package:flex_out/database.dart';
import 'package:flex_out/FlexAssets.dart';
import 'package:flex_out/Lang.dart';
import 'package:flex_out/structures/Class.dart';

import 'package:flex_out/screens/Student/widgets/ClassCard.dart';

class STU_Classes extends StatefulWidget {
  STU_Classes({Key key, this.title}) : super(key: key);
  final String title;

  @override
  STU_ClassesState createState() => STU_ClassesState();
}

class STU_ClassesState extends State<STU_Classes> {
  //20 char Limit
  List<FlexClass> classes = Database.getClasses();
  List<Widget> listItems;

  @override
  Widget build(BuildContext context) {
    //requests = Database.getRequests(User.current.email);
    listItems = new List();

    for(FlexClass c in classes)
      listItems.add(STU_ClassCard(c,this));

    return new Scaffold(
        appBar: AppBar(
          leading: MaterialButton(
              child: FlexIcons.BACK_ARROW,
              onPressed: () {Navigator.of(context).pop();}),
          title: Text(Lang.trans("classes_title")),
          backgroundColor: FlexColors.BF_PURPLE,
        ),
        backgroundColor: Colors.grey[300],
        body: ListView(children: listItems),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: FlexColors.BF_PURPLE,
        foregroundColor: Colors.white,
        onPressed: () {Navigator.of(context).pushNamed('/stu/joinclass/teacher');},
      ),
    );
  }

  void leave_class(FlexClass c) {
    setState(() {
      classes.remove(c);
      Database.leave_class(c);
    });
  }

}