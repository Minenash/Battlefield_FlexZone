import 'Request.dart';
import 'Class.dart';
import 'Responce.dart';
import 'Teacher.dart';

List<Request> getTestRequests(String email) {
  List<Request> requests = new List();
  requests.add(new Request(
      0,
      null,
      "Ryan Frank",
      "Test Retake",
      true,
      false,
      FlexClass(0, 2, "Calc", Teacher("Mr.", "Brian", "Merrmans")),
      FlexClass(1, 3, "History", Teacher("Mrs.", "Dianna", "Ganow")),
      Responce.approved,
      Responce.waiting,
      "12:34 AM",
      null,
      "lol",
      null));

  requests.add(new Request(
      1,
      null,
      "Ryan Frank",
      "Study Help",
      true,
      true,
      FlexClass(2, 4, "Physics", Teacher("Mr.", "Eric", "Masalake")),
      FlexClass(3, 7, "Networking", Teacher("Mr.", "Brain", "Metts")),
      Responce.approved,
      Responce.approved,
      "12:34 AM",
      "Yesterday",
      null,
      null));

  requests.add(new Request(
      2,
      null,
      "Ryan Frank",
      "IDK Anymore",
      true,
      false,
      FlexClass(4, 1, "Class A", Teacher("Title", "First", "Teacher A")),
      FlexClass(4, 6, "Class B", Teacher("Title", "First", "Teacher B")),
      Responce.approved,
      Responce.denied,
      "12:34 AM",
      "Yesterday",
      "lol",
      null));

  return requests;
}

List<FlexClass> getTestClasses(String email) {
  List<FlexClass> classes = new List();

  classes.add(new FlexClass(0, 1, "Earth Science", Teacher("Mr.", "Eric", "Maskelak")));
  classes.add(new FlexClass(1, 2, "Adv. Database", Teacher("Prof.", "Gail", "Drake")));
  classes.add(new FlexClass(2, 3, "Civics", Teacher("Mrs.", "Dianna", "Ganow")));

  return classes;
}

List<Teacher> getTeachers() {
  List<Teacher> teachers = new List();

  teachers.add(Teacher("Mr.", "Justin", "Wong"));
  teachers.add(Teacher("Mrs.", "Jennifer", "Johnson"));
  teachers.add(Teacher("Prof.", "Gail", "Drake"));
  teachers.add(Teacher("Dr.", "Brady", "Haren"));

  return teachers;
}

List<FlexClass> getTeacherClasses(Teacher t) {
  List<FlexClass> classes = new List();

  classes.add(new FlexClass(0, 1, "Earth Science", Teacher("Mr.", "Eric", "Maskelak")));
  classes.add(new FlexClass(1, 2, "Adv. Database", Teacher("Prof.", "Gail", "Drake")));
  classes.add(new FlexClass(2, 3, "Civics", Teacher("Mrs.", "Dianna", "Ganow")));

  return classes;
}