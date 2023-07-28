part of 'auth_bloc.dart';

class AuthEvent {}

class CheckIfLoggedIn extends AuthEvent {
  CheckIfLoggedIn();
}

class Login extends AuthEvent {
  final String userId;
  Login({required this.userId});
}

class Logout extends AuthEvent {}
