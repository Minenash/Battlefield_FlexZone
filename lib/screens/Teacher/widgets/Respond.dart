import 'package:flutter/material.dart';
import 'package:flex_out/Lang.dart';
import 'package:flex_out/database.dart';
import 'package:flex_out/FlexAssets.dart';
import 'package:flex_out/structures/Request.dart';
import 'package:flex_out/structures/Responce.dart';
import 'package:flex_out/screens/Teacher/widgets/RequestCardMultiSelect.dart';

class Respond extends StatefulWidget {

  List<Request> reqs;
  Responce res;
  State access;

  Respond(this.reqs, this.res, this.access, {Key key, this.title}) : super(key: key);
  final String title;

  @override
  RespondState createState() => RespondState(reqs, res, access);
}

class RespondState extends State<Respond> {

  TextEditingController reasonController = new TextEditingController();
  List<Request> reqs;
  Responce res;
  State access;

  RespondState(this.reqs, this.res, this.access);
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(Lang.trans('reason') + ":"),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top:10, left: 10),
            height: 100,
            width: 250,
            child: TextField(
                controller: reasonController,
                decoration: InputDecoration(
                    labelText: "(${Lang.trans('optional')})",
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontStyle: FontStyle.italic,
                        color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: FlexColors.BF_PURPLE)
                    )
                ),
              onSubmitted: (_) {create();},
            )
          ),
        ],
      ),
      actions: <Widget>[
        MaterialButton(
          child: Text(Lang.trans('done_button')),
          onPressed: () { create(); },
        )
      ],
    );
  }

  void create() {
    setState(() {
      Navigator.of(context).pop();
      for (Request req in reqs)
        Database.respond(req, res, reasonController.text);

      TEA_RequestCardMSState.setAllSelected(false);

      if (access != null)
        access.setState(() {});
    });
  }
}