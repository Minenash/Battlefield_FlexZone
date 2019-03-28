import 'package:flutter/material.dart';

class FlexIcons {
  
  static const APP = Icon(IconData(0xe900, fontFamily: 'custom_icons'), color: Colors.white, size: 40);
  static const BACK_ARROW = Icon(Icons.arrow_back, color: Colors.white, size: 25);
  static const BACK_CARET = Icon(Icons.navigate_before, size: 30, color: Colors.white);

  static const NO_CONNECTION = Icon(IconData(0xe900, fontFamily: 'custom_icons'), color: Colors.black, size: 120);

  static const APPROVED = Icon(Icons.done, color: Colors.green);
  static const DENIED = Icon(Icons.close, color: Colors.red);
  static const WAITING = Icon(Icons.alarm, color: Colors.blueGrey);
  static const ALL_APPROVED = Icon(Icons.done_all, color: Colors.green);
  static const IRRELEVANT = Icon(Icons.alarm_off, color: Colors.blueGrey);
  static const CANCELLED = Icon(Icons.not_interested, color: Colors.red);

  static const APPROVED_BIG = Icon(Icons.done, color: Colors.green, size: 30);
  static const DENIED_BIG = Icon(Icons.close, color: Colors.red, size: 30);
  static const WAITING_BIG = Icon(Icons.alarm, color: Colors.blueGrey, size: 30);
  static const ALL_APPROVED_BIG = Icon(Icons.done_all, color: Colors.green, size: 30);
  static const IRRELEVANT_BIG = Icon(Icons.alarm_off, color: Colors.blueGrey, size: 30);
  static const CANCELLED_BIG = Icon(Icons.not_interested, color: Colors.red, size: 30);

  static const CLASS_LEADING = Icon(Icons.class_, size: 35, color: Colors.black);
  static const CLASS_DELETE = Icon(Icons.delete, size: 25, color: Colors.black);

  static const TEACHER_LEADING = Icon(Icons.person, size: 50, color: Colors.black);
  static const TEACHER_NEXT = Icon(Icons.navigate_next, size: 25, color: Colors.black);
}

class FlexColors {
  static const BF_PURPLE = Color(0xFF501076);
}