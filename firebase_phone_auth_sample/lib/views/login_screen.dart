import 'package:firebase_phone_auth_sample/extensions/input_validator.dart';
import 'package:firebase_phone_auth_sample/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final input = authProvider.inputController.text;
    if (input.isValidEmail()) {
      final email = input;
      if (await authProvider.emailSignedUp(email)) {
        // to email login page
        authProvider.authState = AuthState.emailLogin;
      } else {
        // to email signup page
        authProvider.authState = AuthState.emailSignup;
      }
    } else if (input.isValidPhoneNumber()) {
      final phoneNumber = '+82${input.replaceAll('-', '')}';
      authProvider.loginWithPhoneNumber(phoneNumber);
    }
  }

  String? _inputValidator(String? value) {
    if (value == null) return '이메일 또는 전화번호를 입력해주세요';

    if (value.isValidEmail() || value.isValidPhoneNumber()) {
      return null;
    }

    return '이메일 또는 전화번호를 입력해주세요';
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: authProvider.inputController,
                decoration:
                    const InputDecoration(hintText: '이메일 또는 전화번호를 입력해주세요'),
                validator: _inputValidator,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _login,
                      child: const Text('로그인'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
