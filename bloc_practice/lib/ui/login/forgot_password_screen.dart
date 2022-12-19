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
        appBar: AppBar(),
        body: Column(
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
    );
  }
}
