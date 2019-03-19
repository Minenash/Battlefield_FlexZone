class Teacher {
  final String first_name, last_name, title, department;

  Teacher(this.title, this.first_name, this.last_name, {this.department = ""});

  String title_last() => title + " " + last_name;
  String last_first() => last_name + ", " + first_name;

}