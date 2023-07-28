import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metamask_authentication_practice/services/wallet_service.dart';

class LoginScreen extends GetView<WalletService> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () => controller.connectToMetamask(),
                child: const Text("Connect with Metamask"))
          ],
        ),
      ),
    );
  }
}
