class UserSession {
  static String currentUserEmail = '';

  static void setUserEmail(String email) {
    currentUserEmail = email;
  }

  static String getUserEmail() {
    return currentUserEmail;
  }
}
