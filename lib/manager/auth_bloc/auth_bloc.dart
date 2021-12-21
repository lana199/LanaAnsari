import 'dart:async';

import 'package:assitant2/repositories/firebase_auth_repository.dart';
import 'package:assitant2/util/error/auth_error.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FireBaseAuthRepository _repository;

  AuthBloc(this._repository) : super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthAccountCreated) {
      yield* _authCreateAccountHandler(event.email, event.password);
    } else if (event is AuthAccountLoggedIn) {
      yield* _authLoginHandler(event.email, event.password);
    } else if (event is AuthStateChecked) {
      yield* _authStateCheckedHandler();
    } else if (event is AuthGoogleAccountLoggedIn) {
      yield* _athGoogleAccountLoggedInHandler();
    }
  }

  Stream<AuthState> _authLoginHandler(String email, String password) async* {
    yield AuthInProgress();
    try {
      var _userCredential = await _repository.login(email, password);
      yield AuthSuccess(_userCredential.user);
    } on UserNotFound catch (e) {
      yield AuthFailure(e.msg);
    } on WrongPassword catch (e) {
      yield AuthFailure(e.msg);
    } on Exception {
      yield AuthFailure('حدث خطأ ما يرجى المحاولة لاحقا.');
    }
  }

  Stream<AuthState> _authCreateAccountHandler(
      String email, String password) async* {
    yield AuthInProgress();
    try {
      var _userCredential = await _repository.createAccount(email, password);
      yield AuthSuccess(_userCredential.user);
    } on WeakPassword catch (e) {
      yield AuthFailure(e.msg);
    } on EmailAlreadyInUse catch (e) {
      yield AuthFailure(e.msg);
    } on Exception {
      yield AuthFailure('حدث خطأ ما يرجى المحاولة لاحقا.');
    }
  }

  // if the user already logged-in
  Stream<AuthState> _authStateCheckedHandler() async* {
    var _user = _repository.getUser(); // get current user

    if (_user != null) {
      yield AuthSuccess(_user);
    }
  }

  Stream<AuthState> _athGoogleAccountLoggedInHandler() async* {
    yield AuthInProgress();
    try {
      var _userCredential = await _repository.signInWithGoogle();
      yield AuthSuccess(_userCredential.user);
    } on SignInAborted catch (e) {
      yield AuthFailure(e.msg);
    } on Exception {
      yield AuthFailure('حدث خطأ ما يرجى المحاولة لاحقا.');
    }
  }
}
