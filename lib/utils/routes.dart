import 'package:wingman_task/ui/auth/login.dart';
import 'package:wingman_task/ui/home/home_page.dart';
import 'package:flutter/material.dart';

class Routes {
  static Map<String, WidgetBuilder> routes = {
    LoginPage.route: (context) => const LoginPage(),
    HomePage.route: (context) => const HomePage(),
  };
}