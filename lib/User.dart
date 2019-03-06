enum UserType {STUDENT, TEACHER, ADMIN, NONE}

class User {
  String email;
  String first_inital;
  String lastname;
  String hashpass;
  UserType type;

  static User current;

  User(this.email, this.first_inital, this.lastname, this.hashpass, this.type);

  static typeToString(UserType type) {
    return type.toString().substring(9).toLowerCase();
  }
}