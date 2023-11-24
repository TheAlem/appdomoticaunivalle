class UserSession {
  static String currentUserEmail = '';

  static void setUserEmail(String email) {
    currentUserEmail = email;
  }

  static String getUserEmail() {
    return currentUserEmail;
  }
}

//Este codigo sirve para obtener el correo con el que se inicia sesión
