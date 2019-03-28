import 'package:flutter/material.dart';

import 'package:flex_out/database.dart';
import 'package:flex_out/FlexAssets.dart';
import 'package:flex_out/Lang.dart';
import 'package:flex_out/structures/Class.dart';
import 'package:flex_out/main.dart';

import 'package:flex_out/screens/Student/widgets/ClassCard.dart';

class STU_Classes extends StatefulWidget {
  STU_Classes({Key key, this.title}) : super(key: key);
  final String title;

  @override
  STU_ClassesState createState() => STU_ClassesState();
}

class STU_ClassesState extends State<STU_Classes> {
  List<FlexClass> classes;
  List<Widget> listItems;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          leading: MaterialButton(
              child: FlexIcons.BACK_ARROW,
              onPressed: () {Navigator.of(context).pop();}),
          title: Text(Lang.trans("classes_title")),
          backgroundColor: FlexColors.BF_PURPLE,
        ),
        backgroundColor: Colors.grey[300],
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: FlexColors.BF_PURPLE,
        foregroundColor: Colors.white,
        onPressed: () {Navigator.of(context).pushNamed('/stu/joinclass/teacher');},
      ),
      body: FutureBuilder(
        future: Database.getClasses(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            classes = snapshot.data;
            listItems = new List();

            for(FlexClass c in classes)
              listItems.add(STU_ClassCard(c,this));

            return ListView(children: listItems);
          }
          return loading;
        },
      )
    );
  }

  void leave_class(FlexClass c) {
    print("1");
    Database.leave_class(c).then((_) {setState(() {});});
  }

}