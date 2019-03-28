import 'package:flutter/material.dart';

import 'package:flex_out/database.dart';
import 'package:flex_out/FlexAssets.dart';
import 'package:flex_out/Lang.dart';
import 'package:flex_out/structures/Class.dart';
import 'package:flex_out/structures/Teacher.dart';
import 'package:flex_out/main.dart';

import 'package:flex_out/screens/Student/widgets/TeacherCard.dart';

class STU_JoinClass_Teacher extends StatelessWidget {
  //20 char Limit
  List<Teacher> teachers;
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
      body: FutureBuilder(
        future: Database.getTeachers(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            teachers = snapshot.data;
            listItems = new List();

            for(Teacher t in teachers)
              listItems.add(STU_TeacherCard(t,context));

            return ListView(children: listItems);
          }
          return loading;
        },
      )
    );
  }

}

class STU_JoinClass_Class extends StatelessWidget{
  //20 char Limit
  List<FlexClass> classes;
  Teacher teacher;
  List<Widget> listItems;

  STU_JoinClass_Class(Teacher teacher) {
    this.teacher = teacher;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        leading: MaterialButton(
            child: FlexIcons.BACK_CARET,
            onPressed: () {Navigator.of(context).pop();}),
        title: Text(Lang.trans("classes_title")),
        backgroundColor: FlexColors.BF_PURPLE,
      ),
      backgroundColor: Colors.grey[300],
      body: FutureBuilder(
        future: Database.getTeacherClasses(teacher),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            classes = snapshot.data;
            listItems = new List();

            for(FlexClass c in classes)
              listItems.add(STU_TeacherClassCard(c));

            return ListView(children: listItems);
          }
          return loading;
        },
      )
    );
  }

}