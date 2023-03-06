import 'package:firebase_phone_auth_sample/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  _verified() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (await authProvider.checkIfVerified()) {
      authProvider.authState = AuthState.loggedIn;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('이메일이 인증되지 않았습니다.'),
        ),
      );
    }
  }

  _resendVerificationEmail() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.resendVerificationEmail();
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
              '${authProvider.inputController.text}로 인증이메일이 전송되었습니다. 확인해주세요.',
              style: const TextStyle(overflow: TextOverflow.visible),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _verified,
                    child: const Text('확인'),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: _resendVerificationEmail,
              child: Text('인증이메일 재전송', style: TextStyle(color: Colors.black26)),
            ),
          ],
        ),
      ),
    );
  }
}
