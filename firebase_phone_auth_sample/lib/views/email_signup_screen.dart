import 'package:firebase_phone_auth_sample/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailSignupScreen extends StatefulWidget {
  const EmailSignupScreen({super.key});

  @override
  State<EmailSignupScreen> createState() => _EmailSignupScreenState();
}

class _EmailSignupScreenState extends State<EmailSignupScreen> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _signup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String email = authProvider.inputController.text;
    String password = _passwordController.text;
    await authProvider.signupWithEmail(
      email: email,
      password: password,
    );
  }

  String? _passwordValidator(String? value) {
    if (value == null) {
      return '비밀번호를 입력해주세요.';
    }
    if (value.length < 8) {
      return '8자 이상 입력해주세요.';
    }
    return null;
  }

  String? _passwordCheckValidator(String? value) {
    if (value != _passwordController.text) {
      return '비밀번호가 일치하지 않습니다!';
    }
    return null;
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
                readOnly: true,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(hintText: '비밀번호를 입력해주세요.'),
                validator: _passwordValidator,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(hintText: '비밀번호를 확인해주세요.'),
                obscureText: true,
                validator: _passwordCheckValidator,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _signup,
                      child: const Text('인증'),
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
