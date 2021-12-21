part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class AuthAccountCreated extends AuthEvent {
  final String email;
  final String password;

  const AuthAccountCreated(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class AuthAccountLoggedIn extends AuthEvent {
  final String email;
  final String password;

  const AuthAccountLoggedIn(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class AuthStateChecked extends AuthEvent {
  const AuthStateChecked();

  @override
  List<Object> get props => [];
}

class AuthGoogleAccountLoggedIn extends AuthEvent {
  const AuthGoogleAccountLoggedIn();

  @override
  List<Object> get props => [];
}
