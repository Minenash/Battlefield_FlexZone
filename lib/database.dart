import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flex_out/structures/User.dart';
import 'package:flex_out/structures/Request.dart';
import 'package:flex_out/Lang.dart';
import 'package:flex_out/structures/Class.dart';
import 'package:flex_out/structures/Teacher.dart';
import 'package:flex_out/structures/Responce.dart';

enum VerifyResults {ADMIN, TEACHER, STUDENT, NO_MATCH, DATABASE_ERROR}
enum ConnectionResult {OKAY, CANNOT_CONNECT, ERROR}

class Database {

  static MySqlConnection connection;
  static ConnectionResult result;
  static String error;

  static Future<ConnectionResult> init() async {

    try {
      connection = await MySqlConnection.connect(
          ConnectionSettings(
              host: "sql9.freemysqlhosting.net",
              port: 3306,
              user: "sql9285100",
              password: "7YF9JQryFd",
              db: "sql9285100"
          )
      );
    }
    on SocketException catch (e) {
      error = e.toString();
      return ConnectionResult.CANNOT_CONNECT;
    }
    catch (e) {
      error = e.toString();
      return ConnectionResult.ERROR;
    }
    return ConnectionResult.OKAY;
  }

  static Results query(String q, Iterable i) {
    try {
      connection.query(q,i);
    }
    catch (e) {
      return null;
    }
  }

  static final RegExp emailValidation = new RegExp(
      r"[\w.+#-]+@[\w.-]+\.[a-z]{2,}", caseSensitive: false);

  static Future<VerifyResults> verify_login(String email_in, String password) async {
    email_in = email_in.toLowerCase();

    print(email_in);
    print(password);

    Results results = await connection.query("SELECT * FROM `pwcs_users` WHERE email = '$email_in' AND hashpass = '$password'");

    if (results.isEmpty)
      return VerifyResults.NO_MATCH;

    var r = results.first;

    // r[5] is account_type
    UserType type = r[5] == 1 ? UserType.STUDENT
        : r[5] == 2 ? UserType.TEACHER
        : UserType.NONE;

    if (type == UserType.NONE)
      return VerifyResults.DATABASE_ERROR;

    int user_id = r[0];
    String title = r[7], firstname = r[2], lastname = r[3];

    User.current = new User(user_id, email_in, firstname, lastname, type);

    if (type != UserType.STUDENT)
      Teacher.current = Teacher(user_id, title, firstname, lastname);

    final storage = new FlutterSecureStorage();

    await storage.deleteAll();

    await storage.write(key: "email", value: email_in);
    await storage.write(key: "hashpass", value: password);
    await storage.write(key: "type", value: "$r[5]");
    await storage.write(key: "langauge", value: Lang.code);

    return type == UserType.STUDENT? VerifyResults.STUDENT : VerifyResults.TEACHER;
  }

  static bool isEmailValid(String email) {
    return emailValidation.hasMatch(email);
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

      await verify_login(email, hashpass);
    }
    catch (e) {
      await storage.deleteAll();
    }
    return true;
  }

  static Future<List<Request>> getRequests() async {

    Results res1 = await connection.query("SELECT * FROM `flex_requests` WHERE student_id = ${User.current.id}");

    List<Request> requests = new List();

    for (var r in res1) {
      Results res2 = await connection.query("SELECT first_name, last_name FROM pwcs_users WHERE user_id = ${r[2]}");
      Results res3 = await connection.query("SELECT * FROM classes WHERE class_id = ${r[3]}");
      Results res4 = await connection.query("SELECT * FROM classes WHERE class_id = ${r[4]}");
      Results res5 = await connection.query("SELECT * FROM pwcs_users WHERE user_id = ${res3.first[1]}");
      Results res6 = await connection.query("SELECT * FROM pwcs_users WHERE user_id = ${res4.first[1]}");

      Responce r_from = r[11] == null ? Responce.waiting : r[11] == 0? Responce.denied : Responce.approved;
      Responce r_to = r[12] == null ? Responce.waiting : r[12] == 0? Responce.denied : Responce.approved;

      String stu_name = res2.first[0] + " " + res2.first[1];

      FlexClass c_from = new FlexClass(res3.first[0], res3.first[2], res3.first[3], new Teacher(res5.first[0], res5.first[7], res5.first[2], res5.first[3]));
      FlexClass c_to = new FlexClass(res4.first[0], res4.first[2], res4.first[3], new Teacher(res6.first[0], res6.first[7], res6.first[2], res6.first[3]));

      requests.add(new Request(r[0], r[1].toString(), stu_name, r[10], r[9] == 1, r[5] == 1, c_from, c_to, r_from, r_to, r[13], r[14], r[15], r[16], r[6] == 1, r[7] == 1, r[8] == 1));
    }
    return requests;
    //return await TestData.getTestRequests(User.current.email);
  }

  static Future<List<FlexClass>> getClasses() async {
    
    List<FlexClass> classes = new List();
    Results results = await connection.query("SELECT * FROM `assigned_class` a JOIN `classes` c USING (class_id) JOIN `pwcs_users` u ON (c.teacher_id = u.user_id) WHERE a.user_id = ${User.current.id}");
    
    for (var r in results) {
      classes.add(new FlexClass(r[0], r[3], r[4], new Teacher(r[7], r[14], r[9], r[10])));
    }

    return classes;
    
  }

  static Future<List<Teacher>> getTeachers() async {
    List<Teacher> teachers = new List();

    Results results = await connection.query("SELECT * FROM `pwcs_users` WHERE account_type = 2");

    for (var r in results) {
      print(r);
      teachers.add(new Teacher(r[0], r[7], r[2], r[3]));
    }

    return teachers;
  }

  static Future<List<FlexClass>> getTeacherClasses(Teacher t) async {

    List<FlexClass> classes = new List();
    Results results = await connection.query("SELECT * FROM `classes` WHERE teacher_id = ${t.id}");

    for (var r in results) {
      classes.add(new FlexClass(r[0], r[2], r[3], t));
    }

    return classes;
  }

  static Future<void> archive(Request r) async {
    await connection.query("UPDATE `flex_requests` SET `archive_stu` = '1' WHERE `flex_requests`.`flex_pass_id` = ${r.id}").then((v) {
      return true;
    });
  }

  static Future<void> unarchive(Request r) async {

    await connection.query("UPDATE `flex_requests` SET `archive_stu` = '0' WHERE `flex_requests`.`flex_pass_id` = ${r.id}").then((v) {
      return true;
    });
  }

  static Future<void> cancel(Request r) async {
    await connection.query("UPDATE `flex_requests` SET `cancelled` = '1', `time_from` = NULL, `time_to` = NULL WHERE `flex_requests`.`flex_pass_id` = ${r.id}").then((v) {
      return true;
    });
  }

  static Future<void> leave_class(FlexClass c) async {
    await connection.query("DELETE FROM `assigned_class` WHERE `assigned_class`.`user_id` = ${User.current.id} AND `assigned_class`.`class_id` = ${c.id}").then((v) {
      return true;
    });
  }

  static Future<void> add_class(FlexClass c) async {
    await connection.query("INSERT INTO `assigned_class` (`user_id`, `class_id`) VALUES ('${User.current.id}', '${c.id}')").then((v) {
      return true;
    });
  }

  static Future<void> create_request(FlexClass from, FlexClass to, String reason) async {
    await connection.query("INSERT INTO `flex_requests`"
        "(`flex_pass_id`, `time_stamp`, `student_id`, `class_from`, `class_to`, `cancelled`,"
        "`archive_stu`, `archive_from`, `archive_to`, `deniable`, `description`, `teacher_to_ans`,"
        "`teacher_from_ans`, `time_from`, `time_to`, `t_r_one`, `t_r_two`)"

        "VALUES (NULL, CURRENT_TIMESTAMP, '${User.current.id}', '${from.id}', '${to.id}', '0', '0', '0', '0', '0',"
        "'$reason', NULL, NULL, NULL, NULL, NULL, NULL);").then((v) {
      return true;
    });
  }

  static void create_class(String name) {
    print("Database: Class Created");
  }

  static void delete_class(FlexClass c) {
    print("Database: Class Deleted");
  }

  static void respond(Request req, Responce res, String reason) {
    print("Database: Responded");
  }
}