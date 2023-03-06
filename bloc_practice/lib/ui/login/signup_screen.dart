import 'package:bloc_practice/blocs/auth/auth_bloc.dart';
import 'package:bloc_practice/ui/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatefulWidget {
  static GoRoute route = GoRoute(
    name: 'signup',
    path: '/signup',
    builder: (context, state) => const SignupScreen(),
  );
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  void _onSignup(BuildContext context) {
    if (_formKey.currentState == null) {
      return;
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }
    print('_onSignup');
    BlocProvider.of<AuthBloc>(context).add(
      SignupRequested(_emailTextController.text, _passwordTextController.text),
    );
    BlocProvider.of<AuthBloc>(context).add(
      SendVerificationEmailRequested(),
    );
  }

  _blocListener(BuildContext context, AuthState state) {
    if (state is EmailNotVerified) {
      context.pop();
      context.pushNamed('email_verification', queryParams: {
        'email': _emailTextController.text,
      });
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
          listener: _blocListener,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: Common.defaultPadding),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    validator: CustomValidator.validateEmail,
                    controller: _emailTextController,
                    decoration: const InputDecoration(
                      hintText: 'Enter email',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    validator: CustomValidator.validatePassword,
                    controller: _passwordTextController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Enter password',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    validator: (value) =>
                        CustomValidator.validateReneteredPassword(
                            value, _passwordTextController.text),
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Re-enter password',
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _onSignup(context),
                          child: const Text("Signup"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
