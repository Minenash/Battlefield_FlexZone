import 'package:flex_out/structures/Request.dart';
import 'package:flex_out/structures/Class.dart';
import 'package:flex_out/structures/Responce.dart';
import 'package:flex_out/structures/Teacher.dart';

List<Request> getTestRequests(String email) {
  List<Request> requests = new List();
  requests.add(new Request(
      0,
      null,
      "Ryan Frank",
      "Test Retake",
      true,
      false,
      FlexClass(0, 2, "Calc", Teacher(0,"Mr.", "Brian", "Merrmans")),
      FlexClass(1, 3, "History", Teacher(3,"Mrs.", "Dianna", "Ganow")),
      Responce.approved,
      Responce.waiting,
      "12:34 AM",
      null,
      "lol",
      null));

  requests.add(new Request(
      1,
      "Yesterday",
      "Ryan Frank",
      "Study Help",
      true,
      true,
      FlexClass(2, 4, "Physics", Teacher(1,"Mr.", "Eric", "Masalake")),
      FlexClass(0, 2, "Calc", Teacher(0,"Mr.", "Brian", "Merrmans")),
      Responce.approved,
      Responce.approved,
      "12:34 AM",
      "99/99/99",
      null,
      null));

  requests.add(new Request(
      2,
      null,
      "Ryan Frank",
      "IDK Anymore",
      true,
      false,
      FlexClass(0, 2, "Calc", Teacher(0,"Mr.", "Brian", "Merrmans")),
      FlexClass(4, 6, "Class B", Teacher(5,"Title", "First", "Teacher B")),
      Responce.waiting,
      Responce.denied,
      "12:34 AM",
      "Yesterday",
      "lol",
      null));

  return requests;
}

List<FlexClass> getTestClasses(String email) {
  List<FlexClass> classes = new List();

  classes.add(new FlexClass(0, 1, "Earth Science", Teacher(1,"Mr.", "Eric", "Maskelak")));
  classes.add(new FlexClass(1, 2, "Adv. Database", Teacher(6,"Prof.", "Gail", "Drake")));
  classes.add(new FlexClass(2, 3, "Civics", Teacher(3, "Mrs.", "Dianna", "Ganow")));

  return classes;
}

List<Teacher> getTeachers() {
  List<Teacher> teachers = new List();

  teachers.add(Teacher(8,"Mr.", "Justin", "Wong"));
  teachers.add(Teacher(9,"Mrs.", "Jennifer", "Johnson"));
  teachers.add(Teacher(6,"Prof.", "Gail", "Drake"));
  teachers.add(Teacher(7,"Dr.", "Brady", "Haren"));

  return teachers;
}

List<FlexClass> getTeacherClasses(Teacher t) {
  List<FlexClass> classes = new List();

  classes.add(new FlexClass(0, 1, "Earth Science", Teacher(1,"Mr.", "Eric", "Maskelak")));
  classes.add(new FlexClass(1, 2, "Adv. Database", Teacher(6,"Prof.", "Gail", "Drake")));
  classes.add(new FlexClass(2, 3, "Civics", Teacher(3,"Mrs.", "Dianna", "Ganow")));

  return classes;
}