import 'package:flex_out/Class.dart';
import 'package:flex_out/Responce.dart';

class Request {
  int id;
  String timestamp;
  String student_name;
  String description;
  bool deniable;

  FlexClass from;
  FlexClass to;

  Responce from_responce;
  Responce to_responce;

  String from_time;
  String to_time;

  String from_reason;
  String to_reason;

  Request(this.id, this.timestamp, this.student_name, this.description,
         this.deniable, this.from, this.to, this.from_responce, this.to_responce,
         this.from_time, this.to_time, this.from_reason, this.to_reason);

  //TODO: Make a constructor based of a database row
}