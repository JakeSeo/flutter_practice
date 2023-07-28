part of 'auth_bloc.dart';

class AuthState {}

class Initial extends AuthState {}

class LoggedIn extends AuthState {
  final User user;

  LoggedIn({required this.user});
}

class LoggedOut extends AuthState {}

class Loading extends AuthState {}
