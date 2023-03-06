import 'package:flutter/material.dart';
import 'package:firebase_phone_auth_sample/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String email = authProvider.inputController.text;
    String password = _passwordController.text;
    await authProvider.loginWithEmail(
      email: email,
      password: password,
    );
  }

  _forgotPassword() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.authState = AuthState.forgotPassword;
    bool success = await authProvider
        .sendPasswordResetEmail(authProvider.inputController.text);
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('오류가 발생했습니다. 잠시후 다시 시도해주세요.'),
        ),
      );
    }
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
                decoration: const InputDecoration(hintText: '비밀번호를 입력해주세요.'),
                validator: _passwordValidator,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _login,
                      child: const Text('인증'),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: _forgotPassword,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('비밀번호를 잊으셨습니까?'),
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
