part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthInProgress extends AuthState {
  const AuthInProgress();

  @override
  List<Object> get props => [];
}

class AuthSuccess extends AuthState {
  final User user;

  const AuthSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class AuthFailure extends AuthState {
  final String msg;

  const AuthFailure(this.msg);

  @override
  List<Object> get props => [msg];
}
