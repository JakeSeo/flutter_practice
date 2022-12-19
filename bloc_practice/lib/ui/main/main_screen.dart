import 'package:flutter/material.dart';
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
            Center(
              child: ElevatedButton(
                onPressed: () {
                  context.push('/login');
                },
                child: const Text("Login"),
              ),
            )
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
