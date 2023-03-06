import 'package:bloc_practice/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc({required this.authRepository}) : super(UnAuthenticated()) {
    on<AutoLoginRequested>((event, emit) async {
      emit(Loading());
      await Future.delayed(const Duration(seconds: 3));
      if (authRepository.isLoggedIn()) {
        if (await authRepository.isEmailVerified()) {
          emit(Authenticated());
        } else {
          emit(EmailNotVerified());
        }
      } else {
        emit(UnAuthenticated());
      }
    });
    on<SendVerificationEmailRequested>((event, emit) async {
      emit(Loading());
      try {
        await authRepository.sendEmailVerificationEmail();
        emit(EmailNotVerified());
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });
    on<CheckEmailVerificationRequested>((event, emit) async {
      emit(Loading());
      try {
        if (await authRepository.isEmailVerified()) {
          emit(Authenticated());
        } else {
          emit(AuthError('Email not verified yet!'));
          emit(EmailNotVerified());
        }
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(EmailNotVerified());
      }
    });
    // When User Presses the SignIn Button, we will send the SignInRequested Event to the AuthBloc to handle it and emit the Authenticated State if the user is authenticated
    on<LoginRequested>((event, emit) async {
      emit(Loading());
      try {
        await authRepository.login(
            email: event.email, password: event.password);
        if (await authRepository.isEmailVerified()) {
          print('email verified');
          emit(Authenticated());
        } else {
          emit(EmailNotVerified());
        }
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });
    // When User Presses the SignUp Button, we will send the SignUpRequest Event to the AuthBloc to handle it and emit the Authenticated State if the user is authenticated
    on<SignupRequested>((event, emit) async {
      emit(Loading());
      try {
        await authRepository.signup(
            email: event.email, password: event.password);
        emit(EmailNotVerified());
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });
    // When User Presses the Send Reset Password Email Button, we will send the SignOutRequested Event to the AuthBloc to handle it and emit the UnAuthenticated State
    on<SendResetPasswordEmailRequested>((event, emit) async {
      emit(Loading());
      try {
        await authRepository.sendResetPasswordEmail(email: event.email);
        emit(ResetPasswordEmailSent());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
    // When User Presses the SignOut Button, we will send the SignOutRequested Event to the AuthBloc to handle it and emit the UnAuthenticated State
    on<SignoutRequested>((event, emit) async {
      emit(Loading());
      await authRepository.signout();
      emit(UnAuthenticated());
    });
  }
}
