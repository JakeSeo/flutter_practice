import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_phone_auth_sample/app_router.dart';
import 'package:firebase_phone_auth_sample/firebase_options.dart';
import 'package:firebase_phone_auth_sample/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate();

  FlutterNativeSplash.remove();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    authProvider = AuthProvider();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        authProvider.authState = AuthState.loggedOut;
      } else {
        authProvider.inputController.text = user.email ?? '';
        if (user.phoneNumber != null) {
          authProvider.authState = AuthState.loggedIn;
        } else if (user.email != null) {
          if (user.emailVerified) {
            authProvider.authState = AuthState.loggedIn;
          } else {
            print(user);
            authProvider.inputController.text = user.email ?? '';
            authProvider.authState = AuthState.emailVerification;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => authProvider),
        Provider<AppRouter>(create: (_) => AppRouter(authProvider)),
      ],
      child: Builder(
        builder: (context) {
          final GoRouter goRouter =
              Provider.of<AppRouter>(context, listen: false).router;
          return MaterialApp.router(
            title: 'Flutter Demo',
            routerConfig: goRouter,
          );
        },
      ),
    );
  }
}
