import 'package:firebase_phone_auth_sample/views/email_login_screen.dart';
import 'package:firebase_phone_auth_sample/views/email_signup_screen.dart';
import 'package:firebase_phone_auth_sample/views/email_verification_screen.dart';
import 'package:firebase_phone_auth_sample/views/forgot_password_screen.dart';
import 'package:firebase_phone_auth_sample/views/home_screen.dart';
import 'package:firebase_phone_auth_sample/providers/auth_provider.dart';
import 'package:firebase_phone_auth_sample/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'views/phone_number_verification_screen.dart';

class AppRouter {
  late final AuthProvider authProvider;
  GoRouter get router => _router;

  AppRouter(this.authProvider);
  late final GoRouter _router = GoRouter(
    initialLocation: '/',
    refreshListenable: authProvider,
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'verify_phone_number',
            name: 'verify_phone_number',
            builder: (BuildContext context, GoRouterState state) {
              return const PhoneNumberVerificationScreen();
            },
          ),
          GoRoute(
            path: 'email_login',
            name: 'email_login',
            builder: (BuildContext context, GoRouterState state) {
              return const EmailLoginScreen();
            },
          ),
          GoRoute(
            path: 'email_signup',
            name: 'email_signup',
            builder: (BuildContext context, GoRouterState state) {
              return const EmailSignupScreen();
            },
          ),
          GoRoute(
            path: 'email_verification',
            name: 'email_verification',
            builder: (BuildContext context, GoRouterState state) {
              return const EmailVerificationScreen();
            },
          ),
          GoRoute(
            path: 'forgot_password',
            name: 'forgot_password',
            builder: (BuildContext context, GoRouterState state) {
              return const ForgotPasswordScreen();
            },
          ),
        ],
      )
    ],
    redirect: (context, state) {
      final authState = authProvider.authState;

      print('authState: $authState');

      switch (authState) {
        case AuthState.loggedOut:
          return '/login';
        case AuthState.phoneNumberVerification:
          return '/login/verify_phone_number';
        case AuthState.phoneNumberVerificationTimeout:
          return '/login';
        case AuthState.emailSignup:
          return '/login/email_signup';
        case AuthState.emailLogin:
          return '/login/email_login';
        case AuthState.emailVerification:
          return '/login/email_verification';
        case AuthState.forgotPassword:
          return '/login/forgot_password';
        case AuthState.loggedIn:
          return '/';
        default:
          return null;
      }
    },
  );
}
