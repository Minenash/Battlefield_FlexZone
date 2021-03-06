import 'package:flutter/material.dart';

import 'package:flex_out/structures/Class.dart';
import 'package:flex_out/FlexAssets.dart';
import 'package:flex_out/Lang.dart';

import 'package:flex_out/screens/Student/Classes.dart';

class STU_ClassCard extends StatelessWidget {
  
  final FlexClass c;
  final STU_ClassesState parent;
  
  STU_ClassCard(this.c, this.parent);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
            padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
            child: Row (
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row (
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
                            Text.rich(TextSpan(text: Lang.trans('teacher') + ": ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                                children: [TextSpan(text: c.teacher.title_last(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal))
                                ])),
                            Text.rich(TextSpan(text: Lang.trans('period') + ": ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(text: Lang.trans('period_prefix') + c.period.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal))
                                ])),
                          ],
                        ),
                      ]
                  ),
                  RawMaterialButton(
                    child: FlexIcons.CLASS_DELETE,
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                    onPressed: () {
                      parent.leave_class(c);
                    },
                  )

                ]
            )
        )
    );
  }
}