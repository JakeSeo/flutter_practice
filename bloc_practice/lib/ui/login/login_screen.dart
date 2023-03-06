import 'package:bloc_practice/blocs/auth/auth_bloc.dart';
import 'package:bloc_practice/ui/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  static GoRoute route = GoRoute(
    name: 'login',
    path: '/login',
    builder: (context, state) => LoginScreen(),
  );

  LoginScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  void _onLogin(BuildContext context) {
    print('_onLogin');
    BlocProvider.of<AuthBloc>(context).add(
      LoginRequested(_emailTextController.text, _passwordTextController.text),
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
            if (state is Authenticated || state is EmailNotVerified) {
              context.goNamed('home');
            }
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: Common.defaultPadding),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _emailTextController,
                    decoration: const InputDecoration(
                      hintText: 'Enter email',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordTextController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Enter password',
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _onLogin(context),
                          child: const Text("Login"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => context.push('/forgot_password'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Forgot password?",
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => context.push('/signup'),
                          child: const Text("Signup"),
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
      ),
    );
  }
}
