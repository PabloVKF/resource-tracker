import 'package:flutter/material.dart';

import 'pages/authentication_page.dart';
import 'pages/home_page.dart';

class RouteGenerator {
  static const auth = '/';
  static const home = '/home';
  static const history = '/history';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case auth:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return const AuthenticationPage();
          },
        );
      case home:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return const HomePage();
          },
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return const AuthenticationPage();
          },
        );
    }
  }
}
