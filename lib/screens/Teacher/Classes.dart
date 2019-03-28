import 'package:flutter/material.dart';

import 'package:flex_out/database.dart';
import 'package:flex_out/FlexAssets.dart';
import 'package:flex_out/Lang.dart';
import 'package:flex_out/structures/Class.dart';
import 'package:flex_out/TestData.dart' as TestData;

import 'package:flex_out/screens/Teacher/widgets/ClassCard.dart';
import 'package:flex_out/screens/Teacher/widgets/NewClass.dart';

class TEA_Classes extends StatefulWidget {
  TEA_Classes({Key key, this.title}) : super(key: key);
  final String title;

  @override
  TEA_ClassesState createState() => TEA_ClassesState();
}

class TEA_ClassesState extends State<TEA_Classes> {
  //20 char Limit
  List<FlexClass> classes;
  List<Widget> listItems;

  bool classNameAlreadyUsed(String name) {
    for (FlexClass c in classes)
      if (name == c.class_name)
        return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    classes = TestData.getTestClasses();
    listItems = new List();

    for(FlexClass c in classes)
      listItems.add(TEA_ClassCard(c,this));

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
        onPressed: () {
          showDialog(context: context,
              builder: (BuildContext context) {
                return NewClass(this);
              });
        },
      ),
    );
  }

  void delete_class(FlexClass c) {
    setState(() {
      classes.remove(c);
      Database.delete_class(c);
    });
  }

}