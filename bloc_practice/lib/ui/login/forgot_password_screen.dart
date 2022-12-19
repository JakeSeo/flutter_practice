import 'package:bloc_practice/ui/common.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static GoRoute route = GoRoute(
    path: '/forgot_password',
    builder: (context, state) => const ForgotPasswordScreen(),
  );
  const ForgotPasswordScreen({super.key});

  void _onSendResetPasswordEmail() {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: Common.defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Enter email',
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _onSendResetPasswordEmail,
                      child: const Text("Send Reset Password Email"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 0),
            ],
          ),
        ),
      ),
    );
  }
}
