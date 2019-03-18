import 'package:flutter/material.dart';

import 'package:flex_out/database.dart';
import 'package:flex_out/FlexAssets.dart';
import 'package:flex_out/Lang.dart';
import 'package:flex_out/Class.dart';
import 'package:flex_out/Teacher.dart';

import 'package:flex_out/Screens/Student/widgets/TeacherCard.dart';

class STU_JoinClass_Teacher extends StatelessWidget {
  //20 char Limit
  List<Teacher> teachers = Database.getTeachers();
  List<Widget> listItems;

  @override
  Widget build(BuildContext context) {
    listItems = new List();

    for(Teacher t in teachers)
      listItems.add(STU_TeacherCard(t,context));

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
    );
  }

}

class STU_JoinClass_Class extends StatelessWidget{
  //20 char Limit
  List<FlexClass> classes;
  List<Widget> listItems;

  STU_JoinClass_Class(Teacher teacher) {
    classes = Database.getTeacherClasses(teacher);
  }

  @override
  Widget build(BuildContext context) {
    //requests = Database.getRequests(User.current.email);
    listItems = new List();

    for(FlexClass c in classes)
      listItems.add(STU_TeacherClassCard(c));

    return new Scaffold(
      appBar: AppBar(
        leading: MaterialButton(
            child: FlexIcons.TEACHER_CLASS_BACK,
            onPressed: () {Navigator.of(context).pop();}),
        title: Text(Lang.trans("classes_title")),
        backgroundColor: FlexColors.BF_PURPLE,
      ),
      backgroundColor: Colors.grey[300],
      body: ListView(children: listItems),
    );
  }

}