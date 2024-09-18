class AuthCredentialsException implements Exception {
  AuthCredentialsException();
}

class AuthEmailInUseException implements Exception {
  AuthEmailInUseException();
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

class AuthFieldEmptyException implements Exception {
  AuthFieldEmptyException();
}

class AuthPasswordMismatchException implements Exception {
  AuthPasswordMismatchException();
}
