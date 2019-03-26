import 'package:flutter/material.dart';
import 'package:flex_out/Lang.dart';
import 'package:flex_out/database.dart';
import 'package:flex_out/FlexAssets.dart';
import 'package:flex_out/screens/Teacher/Classes.dart';

class NewClass extends StatefulWidget {
  
  TEA_ClassesState access;
  
  NewClass(this.access, {Key key, this.title}) : super(key: key);
  final String title;

  @override
  NewClassState createState() => NewClassState(access);
}

class NewClassState extends State<NewClass> {

  final TEA_ClassesState access;

  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = new TextEditingController();

  NewClassState(this.access);
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Create a New Class"),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.class_, size: 45),
          Container(
            padding: EdgeInsets.only(top:10, left: 10),
            height: 100,
            width: 200,
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                    labelText: "CLASS NAME",
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: FlexColors.BF_PURPLE))),
                validator: (name) {
                  if (name.isEmpty)
                    return Lang.trans('no_name_error');
                  if (access.classNameAlreadyUsed(name))
                    return Lang.trans('dublicate_name_error');
                },
                onFieldSubmitted: (_) {create();},
              ),
            )
          ),
        ],
      ),
      actions: <Widget>[
        MaterialButton(
          child: Text(Lang.trans('create_class_button')),
          onPressed: () { create(); },
        )
      ],
    );
  }

  void create() {
    setState(() {
      if (!_formKey.currentState.validate())
        return;

      Navigator.of(context).pop();
      access.setState((){});
      Database.create_class(nameController.text);
    });
  }
}