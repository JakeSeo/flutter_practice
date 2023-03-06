import 'package:bloc_practice/blocs/auth/auth_bloc.dart';
import 'package:bloc_practice/ui/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static GoRoute route = GoRoute(
    name: 'forgot_password',
    path: '/forgot_password',
    builder: (context, state) => ForgotPasswordScreen(),
  );
  ForgotPasswordScreen({super.key});

  final _emailTextController = TextEditingController();

  void _onSendResetPasswordEmail(BuildContext context) {
    print('_onSendResetPasswordEmail');
    BlocProvider.of<AuthBloc>(context).add(
      SendResetPasswordEmailRequested(_emailTextController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is ResetPasswordEmailSent) {
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Reset Password Email Sent!'),
              ));
            }
            if (state is AuthError) {
              final error = state.error;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(error),
              ));
            }

            if (state is UnAuthenticated) {
              context.pop();
            }
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: Common.defaultPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _emailTextController,
                  decoration: const InputDecoration(
                    hintText: 'Enter email',
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _onSendResetPasswordEmail(context),
                        child: const Text("Send Reset Password Email"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
