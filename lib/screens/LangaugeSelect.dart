import 'package:flutter/material.dart';
import 'package:flex_out/Lang.dart';
import 'package:flex_out/database.dart';

class LangaugeSelect extends StatefulWidget {
  
  State access;
  
  LangaugeSelect(this.access, {Key key, this.title}) : super(key: key);
  final String title;

  @override
  LangaugeSelectState createState() => LangaugeSelectState(access);
}

class LangaugeSelectState extends State<LangaugeSelect> {

  String _value = Lang.code;
  State access;
  
  LangaugeSelectState(this.access);
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(Lang.trans('language_dialog_title')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _option('en'),
          _option('es'),
          _option('de'),
        ],
      ),
      actions: <Widget>[
        MaterialButton(
          child: Text(Lang.trans('apply_button')),
          onPressed: () {
            setState(() {
              Navigator.of(context).pop();
              Future.delayed(Duration(milliseconds: 10), () {
                Lang.setLang(_value);
                access.setState((){});
                Database.saveLangauge();
              });
            });
          },
        )
      ],
    );
  }

  Widget _option(String code) {
    return InkWell(
      onTap: () {setState(() {_value = code;});},
      child: Row(
        children: <Widget>[
          Radio( value: code, groupValue: _value, onChanged: (val) {setState(() {_value = val;});} ),
          Text( Lang.languages[code] )
        ],
      ),
    );
  }
}