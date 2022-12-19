import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatelessWidget {
  static GoRoute route = GoRoute(
    path: '/signup',
    builder: (context, state) => const SignupScreen(),
  );
  const SignupScreen({super.key});

  void _onSignup() {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextField(
              decoration: InputDecoration(
                hintText: 'Enter email',
              ),
            ),
            const SizedBox(height: 8),
            const TextField(
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter password',
              ),
            ),
            const SizedBox(height: 8),
            const TextField(
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Re-enter password',
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _onSignup,
                    child: const Text("Signup"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
