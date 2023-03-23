import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:metamask_authentication_practice/routes/app_screens.dart';
import 'package:metamask_authentication_practice/services/auth_service.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (!AuthService.to.isLoggedInValue) {
      return const RouteSettings(name: Routes.login);
    }
    return null;
  }
}
