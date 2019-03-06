import 'package:flex_out/User.dart';
import 'package:flutter_keychain/flutter_keychain.dart';

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

void setCurrentUser(String email, String hashpass, int itype) async {
  //TODO: Get names from database

  UserType type = itype == 1 ? UserType.STUDENT
                : itype == 2 ? UserType.TEACHER
                : itype == 3 ? UserType.ADMIN
                : UserType.NONE;

  User.current = User(email, 'F', "Lastname", "hashpass", type);

  await FlutterKeychain.put(key: "email", value: email);
  await FlutterKeychain.put(key: "hashpass", value: hashpass);
  await FlutterKeychain.put(key: "type", value: "$itype");

}

Future<bool> loadUser() async {

  String email = await FlutterKeychain.get(key: "email");                        print(email);

  if (await email == null)
    return true;

  String hashpass = await FlutterKeychain.get(key: "hashpass");                  print(hashpass);

  if (await hashpass == null)
    return true;

  String stype = await FlutterKeychain.get(key: "type");                         print(stype);

  if (await stype == null)
    return true;

  int itype = await int.parse(stype, onError: (s) => 0);                               print(itype);

  UserType type = await itype == 1 ? UserType.STUDENT
      : itype == 2 ? UserType.TEACHER
      : UserType.ADMIN;

  User.current = await User(email, 'F', "Lastname2", hashpass, type);

  return true;
}