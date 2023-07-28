import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sendbird_sample/blocs/auth/auth_bloc.dart';
import 'package:sendbird_sample/repositories/sendbird_repository.dart';
import 'routes/app_router.dart';

void main() {
  runApp(MyApp(router: AppRouter()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.router});

  final AppRouter router;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) =>
          AuthBloc(repository: SendbirdRepository())..add(CheckIfLoggedIn()),
      child: MaterialApp.router(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routerConfig: router.router,
      ),
    );
  }
}
