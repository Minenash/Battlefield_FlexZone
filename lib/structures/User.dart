enum UserType {STUDENT, TEACHER, ADMIN, NONE}

class User {
  int id;
  String email;
  String firstname;
  String lastname;
  UserType type;

  static User current;

  User(this.id, this.email, this.firstname, this.lastname, this.type);

  static typeToString(UserType type) {
    return type.toString().substring(9).toLowerCase();
  }

  String first_last() => "$firstname $lastname";
}