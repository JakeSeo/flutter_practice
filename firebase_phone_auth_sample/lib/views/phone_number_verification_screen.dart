import 'package:firebase_phone_auth_sample/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhoneNumberVerificationScreen extends StatefulWidget {
  const PhoneNumberVerificationScreen({super.key});

  @override
  State<PhoneNumberVerificationScreen> createState() =>
      _PhoneNumberVerificationScreenState();
}

class _PhoneNumberVerificationScreenState
    extends State<PhoneNumberVerificationScreen> {
  final TextEditingController verificationController = TextEditingController();

  _verify() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.verifyPhoneNumber('000000');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: verificationController,
              decoration: const InputDecoration(hintText: '인증번호를 입력해주세요'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _verify,
                    child: const Text('인증'),
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
