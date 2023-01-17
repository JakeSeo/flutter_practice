import 'package:bloc_practice/blocs/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatefulWidget {
  static GoRoute route = GoRoute(
    path: '/',
    builder: (context, state) => const MainScreen(),
  );
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    BlocProvider.of<AuthBloc>(context).add(
      AutoLoginRequested(),
    );
  }

  _logout() {
    BlocProvider.of<AuthBloc>(context).add(
      SignoutRequested(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: TabBarView(
          controller: _tabController,
          children: [
            const Center(
              child: Text("home"),
            ),
            BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
              if (state is Loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is UnAuthenticated || state is ResetPasswordEmailSent) {
                return Center(
                  child: ElevatedButton(
                    onPressed: () {
                      context.push('/login');
                    },
                    child: const Text("Login"),
                  ),
                );
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Profile"),
                  ElevatedButton(
                    onPressed: _logout,
                    child: const Text("Logout"),
                  )
                ],
              );
            })
          ],
        ),
        bottomNavigationBar: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorPadding: const EdgeInsets.all(5.0),
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(
              icon: Icon(Icons.menu_book),
            ),
            Tab(
              icon: Icon(Icons.person),
            ),
          ],
        ),
      ),
    );
  }
}
