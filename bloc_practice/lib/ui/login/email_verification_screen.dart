import 'package:bloc_practice/blocs/auth/auth_bloc.dart';
import 'package:bloc_practice/ui/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EmailVerificationScreen extends StatelessWidget {
  static GoRoute route = GoRoute(
    name: 'email_verification',
    path: '/email_verification',
    builder: (context, state) =>
        EmailVerificationScreen(email: state.queryParams['email'] ?? 'gjgj'),
  );
  const EmailVerificationScreen({super.key, required this.email});

  final String email;

  _verificationCompleted(BuildContext context) async {
    print('verification completed');
    BlocProvider.of<AuthBloc>(context).add(CheckEmailVerificationRequested());
  }

  _resendVerificationEmail(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(SendVerificationEmailRequested());
  }

  _blocListener(BuildContext context, AuthState state) {
    if (state is Authenticated) {
      context.goNamed('home');
    }
    if (state is AuthError) {
      final error = state.error;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error),
      ));
    }

    if (state is UnAuthenticated) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: _blocListener,
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: Common.defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Verification Email has been sent to $email"),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _verificationCompleted(context),
                      child: const Text("Verification Completed"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _resendVerificationEmail(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Did not receive email?",
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
