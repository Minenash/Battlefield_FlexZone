import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flex_out/structures/User.dart';
import 'package:flex_out/structures/Request.dart';
import 'package:flex_out/TestData.dart' as TestData;
import 'package:flex_out/Lang.dart';
import 'package:flex_out/structures/Class.dart';
import 'package:flex_out/structures/Teacher.dart';

enum VerifyResults {ADMIN, TEACHER, STUDENT, NO_MATCH, DATABASE_ERROR}

class Database {
  static final RegExp emailValidation = new RegExp(
      r"[\w.+#-]+@[\w.-]+\.[a-z]{2,}", caseSensitive: false);

  static VerifyResults verify_login(String email, String password) {
    //TODO: Connect to Database to verify
    switch (email) {
      case "admin@pwcs.edu":
        return VerifyResults.ADMIN;
        break;
      case "teacher@pwcs.edu":
        return VerifyResults.TEACHER;
        break;
      case "student@pwcs.edu":
        return VerifyResults.STUDENT;
        break;
      case "no_match@pwcs.edu":
        return VerifyResults.NO_MATCH;
        break;
      case "database@pwcs.edu":
        return VerifyResults.DATABASE_ERROR;
        break;
    }
    return null;
  }

  static bool isEmailValid(String email) {
    return emailValidation.hasMatch(email);
  }

  static void setCurrentUser(String email, String hashpass, int itype) async {
    //TODO: Get names from database

    UserType type = itype == 1 ? UserType.STUDENT
        : itype == 2 ? UserType.TEACHER
        : itype == 3 ? UserType.ADMIN
        : UserType.NONE;

    User.current = User(email, 'F', "Lastname", "hashpass", type);

    final storage = new FlutterSecureStorage();

    await storage.deleteAll();

    await storage.write(key: "email", value: email);
    await storage.write(key: "hashpass", value: hashpass);
    await storage.write(key: "type", value: "$itype");
    await storage.write(key: "langauge", value: Lang.code);
  }

  static void saveLangauge() async {
    final storage = new FlutterSecureStorage();

    await storage.delete(key: "langauge");
    await storage.write(key: "langauge", value: Lang.code);
  }

  static void logout(BuildContext context) async {
    final storage = new FlutterSecureStorage();

    await storage.delete(key: "email");
    await storage.delete(key: "hashpass");
    await storage.delete(key: "type");

    Navigator.of(context).pushReplacementNamed('/login');
  }

  static Future<bool> loadUser() async {

    final storage = new FlutterSecureStorage();

    String lang;

    try {lang = await storage.read(key: "langauge");}
    catch (e) {await storage.deleteAll(); print("Cleared (#1)");}

    Lang.setLang(lang == null ? 'en' : lang);

    try {
      String email = await storage.read(key: "email");

      if (email == null)
        return true;

      String hashpass = await storage.read(key: "hashpass");

      if (hashpass == null)
        return true;

      String stype = await storage.read(key: "type");

      if (stype == null)
        return true;

      // ignore: deprecated_member_use
      int itype = int.parse(stype, onError: (s) => 0);

      UserType type = itype == 1 ? UserType.STUDENT
          : itype == 2 ? UserType.TEACHER
          : UserType.ADMIN;

      User.current = User(email, 'F', "Lastname2", hashpass, type);
    }
    catch (e) {
      await storage.deleteAll();
    }
    return true;
  }

  static List<Request> getRequests() {
    //TODO: Get from database and parse

    return TestData.getTestRequests(User.current.email);
  }

  static List<Request> getArchivedRequests() {
    //TODO: Get archived requests from database

    return TestData.getTestRequests(User.current.email);
  }

  static List<FlexClass> getClasses() {
    //TODO: Get archived requests from database

    return TestData.getTestClasses(User.current.email);
  }

  static List<Teacher> getTeachers() {
    //TODO: Get Teachers from Database

    return TestData.getTeachers();
  }

  static List<FlexClass> getTeacherClasses(Teacher t) {
    //TODO: Get Teachers from Database

    return TestData.getTeacherClasses(t);
  }

  static void archive(Request r) {
    print("Database: Request Archived");
  }

  static void unarchive(Request r) {
    print("Database: Request Unarchived");
  }

  static void cancel(Request r) {
    print("Database: Request Canceled");
  }

  static void leave_class(FlexClass c) {
    print("Database: Class Left");
  }

  static void add_class(FlexClass c) {
    print("Database: Class Left");
  }

  static void create_request(FlexClass from, FlexClass to, String reason) {
    print("Database: Class Left");
  }
}