import 'package:firebase_phone_auth_sample/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  _goToLoginScreen() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.authState = AuthState.emailLogin;
  }

  _resendPasswordResetEmail() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final email = authProvider.inputController.text;
    authProvider.sendPasswordResetEmail(email);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${authProvider.inputController.text}로 비밀번호 변경 이메일을 보냈습니다. 확인해주세요.',
              style: const TextStyle(overflow: TextOverflow.visible),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _goToLoginScreen,
                    child: const Text('다시 로그인'),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: _resendPasswordResetEmail,
              child: Text('비밀번호 변경 이메일 재전송',
                  style: TextStyle(color: Colors.black26)),
            ),
          ],
        ),
      ),
    );
  }
}
