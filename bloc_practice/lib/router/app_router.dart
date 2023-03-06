import 'package:bloc_practice/ui/login/email_verification_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:bloc_practice/router/screens.dart';

class AppRouter {
  static final router = GoRouter(
    routes: [
      MainScreen.route,
      LoginScreen.route,
      ForgotPasswordScreen.route,
      SignupScreen.route,
      EmailVerificationScreen.route,
    ],
  );
}
