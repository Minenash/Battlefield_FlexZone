import 'package:flutter/material.dart';
import 'package:flex_out/Lang.dart';
import 'package:flex_out/database.dart';
import 'package:flex_out/FlexAssets.dart';

class NewClass extends StatefulWidget {
  
  State access;
  
  NewClass(this.access, {Key key, this.title}) : super(key: key);
  final String title;

  @override
  NewClassState createState() => NewClassState(access);
}

class NewClassState extends State<NewClass> {

  State access;

  TextEditingController nameController = new TextEditingController();

  NewClassState(this.access);
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Create a New CLass"),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.class_, size: 45),
          Container(
            padding: EdgeInsets.only(top:10, left: 10),
            height: 100,
            width: 200,
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                  labelText: "CLASS NAME",
                  labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: FlexColors.BF_PURPLE))),
            )
          ),
        ],
      ),
      actions: <Widget>[
        MaterialButton(
          child: Text("Create"),
          onPressed: () {
            setState(() {
              Navigator.of(context).pop();
              access.setState((){});
              Database.create_class(nameController.text);
            });
          },
        )
      ],
    );
  }
}