import 'package:flex_out/User.dart';

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

void setCurrentUser(String email, String hashpass, VerifyResults result) {
  //TODO: Get names from database

  UserType type = result == VerifyResults.STUDENT ? UserType.STUDENT
                : result == VerifyResults.TEACHER ? UserType.TEACHER
                :                                   UserType.ADMIN;

  User.current = User(email, 'F', "Lastname", "hashpass", type);
}