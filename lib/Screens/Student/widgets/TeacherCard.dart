import 'package:flutter/material.dart';

import 'package:flex_out/FlexAssets.dart';
import 'package:flex_out/Teacher.dart';
import 'package:flex_out/Class.dart';
import 'package:flex_out/SlideRoute.dart';
import 'package:flex_out/database.dart';

import 'package:flex_out/Screens/Student/JoinClass.dart';

class STU_TeacherCard extends StatelessWidget {

  final Teacher t;
  final context;

  STU_TeacherCard(this.t, this.context);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
          child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                        children: [
                          FlexIcons.TEACHER_LEADING,
                          SizedBox(width: 10),
                          Text(t.last_first(), style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold))
                        ]
                    ),
                    FlexIcons.TEACHER_NEXT
                  ]
              )
          ),
          onTap: () {
            Navigator.of(context).push(SlideRightRoute(widget: STU_JoinClass_Class(t)),);},
        )
    );
  }
}


class STU_TeacherClassCard extends StatelessWidget {

  final FlexClass c;

  STU_TeacherClassCard(this.c);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
            child: Container(
                padding: EdgeInsets.only(right: 30, left: 10, top: 10, bottom: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                          children: [
                            FlexIcons.CLASS_LEADING,
                            SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(c.class_name, style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                                SizedBox(height: 5),
                                Text.rich(TextSpan(text: "Teacher: ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                    children: [
                                      TextSpan(text: c.teacher.title_last(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal))
                                    ])),
                                Text.rich(TextSpan(text: "Period: ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                    children: [
                                      TextSpan(text: "P" + c.period.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal))
                                    ])),
                              ],
                            ),
                          ]
                      ),
                      Icon(Icons.add, color: Colors.black,size: 30)
                    ]
                )
            ),
          onTap: () {
              Database.add_class(c);
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed('/stu/classes');
          },
        )
    );
  }
}