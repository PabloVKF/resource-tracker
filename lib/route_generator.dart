import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resource_tracker/modules/resource_tracker/bloc/registry_bloc.dart';
import 'package:resource_tracker/modules/resource_tracker/services/resource_tracker_service.dart';
import 'modules/authentication/blocs/authentication_bloc.dart';
import 'modules/authentication/pages/authentication_page.dart';
import 'modules/authentication/services/authentication_service.dart';
import 'modules/resource_tracker/pages/home_page.dart';

class RouteGenerator {
  static const auth = '/';
  static const home = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case auth:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return BlocProvider(
              create: (context) => AuthenticationBloc(AuthenticationService()),
              child: const AuthenticationPage(),
            );
          },
        );
      case home:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return BlocProvider(
              create: (context) => RegistryBloc(ResourceTrackerService()),
              child: const HomePage(),
            );
          },
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return BlocProvider(
              create: (context) => AuthenticationBloc(AuthenticationService()),
              child: const AuthenticationPage(),
            );
          },
        );
    }
  }
}
