import 'package:bloc_practice/ui/common/common.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatefulWidget {
  static GoRoute route = GoRoute(
    path: '/signup',
    builder: (context, state) => const SignupScreen(),
  );
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey _formKey = GlobalKey<FormState>();

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
        body: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: Common.defaultPadding),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  validator: CustomValidator.validateEmail,
                  decoration: const InputDecoration(
                    hintText: 'Enter email',
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  validator: CustomValidator.validatePassword,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Enter password',
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  validator: CustomValidator.validateReneteredPassword,
                  obscureText: true,
                  decoration: const InputDecoration(
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
        ),
      ),
    );
  }
}
