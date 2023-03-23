import 'package:get/get.dart';
import 'package:metamask_authentication_practice/routes/middlewares/auth_middleware.dart';

import '../views/home/home_screen.dart';
import '../views/login/login_screen.dart';
part 'app_routes.dart';

class AppScreens {
  AppScreens._();

  static const initial = Routes.home;
  static final routes = [
    GetPage(
      middlewares: [
        AuthMiddleware(),
      ],
      name: Routes.home,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginScreen(),
    ),
  ];
}
