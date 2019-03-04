enum VerifyResults {ADMIN, TEACHER, STUDENT, NO_ACCOUNT, WRONG_PASSWORD, DATABASE_ERROR}

VerifyResults verify_login(String email, String password) {
  switch (email) {
    case "a": return VerifyResults.ADMIN; break;
    case "t": return VerifyResults.TEACHER; break;
    case "s": return VerifyResults.STUDENT; break;
    case "n": return VerifyResults.NO_ACCOUNT; break;
    case "w": return VerifyResults.WRONG_PASSWORD; break;
    case "d": return VerifyResults.DATABASE_ERROR; break;
  }
  return null;
}