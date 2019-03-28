import 'package:flex_out/structures/Class.dart';
import 'package:flex_out/structures/Responce.dart';

class Request {
  int id;
  String timestamp;
  String student_name;
  String description;
  bool deniable;
  bool cancelled;

  FlexClass from;
  FlexClass to;

  Responce from_responce;
  Responce to_responce;

  String from_time;
  String to_time;

  String from_reason;
  String to_reason;

  bool arch_stu;
  bool arch_from;
  bool arch_to;

  Request(this.id, this.timestamp, this.student_name, this.description,
         this.deniable, this.cancelled, this.from, this.to, this.from_responce, this.to_responce,
         this.from_time, this.to_time, this.from_reason, this.to_reason, this.arch_stu, this.arch_from, this.arch_to);

  @override
  String toString() {
    return from.class_name + " to " + to.class_name;
  }
  //TODO: Make a constructor based of a database row
}