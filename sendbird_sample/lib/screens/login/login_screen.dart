import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sendbird_sample/blocs/auth/auth_bloc.dart';
import 'package:sendbird_sample/components/custom_button.dart';
import 'package:sendbird_sample/routes/app_routes.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController userIdController = TextEditingController();

  _login(BuildContext context) {
    final userId = userIdController.text;
    if (userId.isEmpty) return;

    BlocProvider.of<AuthBloc>(context).add(Login(userId: userId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoggedIn) {
          context.goNamed(
            AppRoutes.channels.name,
            pathParameters: {
              'channelType': 'open',
            },
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login Screen'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: const InputDecoration(hintText: "사용자 ID"),
                controller: userIdController,
              ),
              const SizedBox(height: 16),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return CustomButton(
                    text: '로그인',
                    isLoading: state is Loading,
                    onPressed: () => _login(context),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
