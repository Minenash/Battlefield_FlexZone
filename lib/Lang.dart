import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';


class Lang {

  static const Map<String, String> languages = {'en':"English", 'es':"Español", 'de':"Deutsch"};

  static String code = 'en';

  static Map<String, String> sentences;

  static Future<bool> load() async {
    String data = await rootBundle.loadString('assets/lang/${Lang.code}.json');
    Map<String, dynamic> _result = json.decode(data);

    Lang.sentences = new Map();
    _result.forEach((String key, dynamic value) {
      Lang.sentences[key] = value.toString();
    });

    return true;
  }

  static String trans(String key) {
    String out = Lang.sentences[key];
    return out == null? "!MISSING TRANSLATION!" : out;
  }

  static void setLang(String code) async {
    if (languages.keys.contains(code)) {
      Lang.code = code;
      await load();
    }
  }
}