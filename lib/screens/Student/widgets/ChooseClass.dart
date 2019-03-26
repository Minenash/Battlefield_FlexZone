import 'package:flutter/material.dart';

import 'package:flex_out/database.dart';
import 'package:flex_out/FlexAssets.dart';
import 'package:flex_out/Lang.dart';
import 'package:flex_out/structures/Class.dart';

import 'package:flex_out/screens/Student/CreateRequest.dart';

class STU_ChooseClass extends StatefulWidget {
  STU_ChooseClass(this.parent, this.index, {Key key, this.title}) : super(key: key);
  final String title;
  final STU_CreateRequestState parent;
  final bool index;

  @override
  STU_ChooseClassState createState() => STU_ChooseClassState(parent, index);
}

class STU_ChooseClassState extends State<STU_ChooseClass> {
  //20 char Limit
  List<FlexClass> classes = Database.getClasses();
  List<Widget> listItems;
  STU_CreateRequestState parent;
  bool index;

  STU_ChooseClassState(this.parent, this.index);

  @override
  Widget build(BuildContext context) {
    //requests = Database.getRequests(User.current.email);
    listItems = new List();

    for(FlexClass c in classes)
      listItems.add(STU_ChooseClassCard(c, this));

    return new Scaffold(
      appBar: AppBar(
        leading: MaterialButton(
            child: FlexIcons.BACK_CARET,
            onPressed: () {Navigator.of(context).pop();}),
        title: Text(Lang.trans("classes_title")),
        backgroundColor: FlexColors.BF_PURPLE,
      ),
      backgroundColor: Colors.grey[300],
      body: ListView(children: listItems),
    );
  }

  void choose_class(FlexClass c) {
    parent.choose_class(c, index);
    Navigator.of(context).pop();
  }

}

class STU_ChooseClassCard extends StatelessWidget {

  final FlexClass c;
  final STU_ChooseClassState parent;

  STU_ChooseClassCard(this.c, this.parent);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Card(
            child: Container(
                padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                child: Row(
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

                      )
                    ]
                )
            )
        ),
      onTap: () { parent.choose_class(c); }
    );
  }
}