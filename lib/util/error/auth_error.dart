class WeakPassword implements Exception {
  final String msg;

  const WeakPassword(this.msg);
}

class EmailAlreadyInUse implements Exception {
  final String msg;

  const EmailAlreadyInUse(this.msg);
}

class UserNotFound implements Exception {
  final String msg;

  const UserNotFound(this.msg);
}

class WrongPassword implements Exception {
  final String msg;

  const WrongPassword(this.msg);
}

class SignInAborted implements Exception {
  final String msg;

  const SignInAborted(this.msg);
}
