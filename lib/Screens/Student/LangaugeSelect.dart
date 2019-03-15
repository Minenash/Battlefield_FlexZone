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
          InkWell(
            onTap: () {setState(() {_value = 'en';});},
            child: Row(
              children: <Widget>[
                Radio( value: 'en', groupValue: _value, onChanged: (val) {setState(() {_value = val;});} ),
                Text( Lang.languages['en'] )
              ],
            ),
          ),
          InkWell(
            onTap: () {setState(() {_value = 'es';});},
            child: Row(
              children: <Widget>[
                Radio( value: 'es', groupValue: _value, onChanged: (val) {setState(() {_value = val;});} ),
                Text( Lang.languages['es'] )
              ],
            ),
          ),
          InkWell(
            onTap: () {setState(() {_value = 'de';});},
            child: Row(
              children: <Widget>[
                Radio( value: 'de', groupValue: _value, onChanged: (val) {setState(() {_value = val;});} ),
                Text( Lang.languages['de'] )
              ],
            ),
          ),
        ],
      ),
      actions: <Widget>[
        MaterialButton(
          child: Text(Lang.trans('apply_button')),
          onPressed: () {
            setState(() {
              Lang.setLang(_value);
              access.setState((){});
              saveLangauge();
              Navigator.of(context).pop();
            });
          },
        )
      ],
    );
  }
}