part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// When the user signing in with email and password this event is called and the [AuthRepository] is called to sign in the user
class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested(this.email, this.password);
}

class SendVerificationEmailRequested extends AuthEvent {
  SendVerificationEmailRequested();
}

class CheckEmailVerificationRequested extends AuthEvent {
  CheckEmailVerificationRequested();
}

// When the user signing up with email and password this event is called and the [AuthRepository] is called to sign up the user
class SignupRequested extends AuthEvent {
  final String email;
  final String password;

  SignupRequested(this.email, this.password);
}

class SendResetPasswordEmailRequested extends AuthEvent {
  final String email;

  SendResetPasswordEmailRequested(this.email);
}

// When the user signing out this event is called and the [AuthRepository] is called to sign out the user
class SignoutRequested extends AuthEvent {}

class AutoLoginRequested extends AuthEvent {}
