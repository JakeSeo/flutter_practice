import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metamask_authentication_practice/services/auth_service.dart';
import 'package:metamask_authentication_practice/services/wallet_service.dart';

import 'routes/app_screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: BindingsBuilder(() {
        Get.put(AuthService());
        Get.put(WalletService());
      }),
      getPages: AppScreens.routes,
      initialRoute: AppScreens.initial,
    );
  }
}
