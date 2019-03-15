import 'package:flex_out/User.dart';
import 'package:flex_out/Request.dart';
import 'package:flex_out/Responce.dart';
import 'package:flex_out/Class.dart';
import 'package:flex_out/Lang.dart';
import 'package:flutter_keychain/flutter_keychain.dart';

enum VerifyResults {ADMIN, TEACHER, STUDENT, NO_MATCH, DATABASE_ERROR}

final RegExp emailValidation = new RegExp(r"[\w.+#-]+@[\w.-]+\.[a-z]{2,}", caseSensitive: false);

VerifyResults verify_login(String email, String password) {
  //TODO: Connect to Database to verify
  switch (email) {
    case "admin@pwcs.edu": return VerifyResults.ADMIN; break;
    case "teacher@pwcs.edu": return VerifyResults.TEACHER; break;
    case "student@pwcs.edu": return VerifyResults.STUDENT; break;
    case "no_match@pwcs.edu": return VerifyResults.NO_MATCH; break;
    case "database@pwcs.edu": return VerifyResults.DATABASE_ERROR; break;
  }
  return null;
}

bool isEmailValid(String email) {
  return emailValidation.hasMatch(email);
}

void setCurrentUser(String email, String hashpass, int itype) async {
  //TODO: Get names from database

  UserType type = itype == 1 ? UserType.STUDENT
                : itype == 2 ? UserType.TEACHER
                : itype == 3 ? UserType.ADMIN
                : UserType.NONE;

  User.current = User(email, 'F', "Lastname", "hashpass", type);

  await FlutterKeychain.put(key: "email", value: email);
  await FlutterKeychain.put(key: "hashpass", value: hashpass);
  await FlutterKeychain.put(key: "type", value: "$itype");
}

void saveLangauge() {
  FlutterKeychain.put(key: "langauge", value: Lang.code);
}

Future<bool> loadUser() async {

  print(Lang.sentences);
  String lang = await FlutterKeychain.get(key: "langauge");

  Lang.setLang(lang == null? 'en' : lang);

  print(Lang.sentences);

  String email = await FlutterKeychain.get(key: "email");

  if (email == null)
    return true;

  String hashpass = await FlutterKeychain.get(key: "hashpass");

  if (hashpass == null)
    return true;

  String stype = await FlutterKeychain.get(key: "type");

  if (stype == null)
    return true;

  // ignore: deprecated_member_use
  int itype = int.parse(stype, onError: (s) => 0);

  UserType type = itype == 1 ? UserType.STUDENT
      : itype == 2 ? UserType.TEACHER
      : UserType.ADMIN;

  User.current = User(email, 'F', "Lastname2", hashpass, type);

  return true;
}

Map<int,Request> getRequests(String email) {
  //TODO: Get from database and parse

  Map<int,Request> requests = new Map();
  requests[0] = new Request(0, null, "Ryan Frank", "Test Retake", true, FlexClass(0,2, "Calc", "Merrmans"), FlexClass(1,3, "History", "Ganow"),
                          Responce.approved, Responce.waiting, "12:34 AM", null,null, null);

  requests[1] = new Request(1, null, "Ryan Frank", "Study Help", true, FlexClass(2,4, "Physics", "Mars"), FlexClass(3,7, "Networking", "Metts"),
      Responce.approved, Responce.approved, "12:34 AM", "Yesterday",null, null);

  requests[2] = new Request(2, null, "Ryan Frank", "IDK Anymore", true, FlexClass(4,1, "Class A", "Teacher A"), FlexClass(4,6, "Class B", "Teacher B"),
      Responce.approved, Responce.denied, "12:34 AM", "Yesterday",null, null);

  return requests;
}

