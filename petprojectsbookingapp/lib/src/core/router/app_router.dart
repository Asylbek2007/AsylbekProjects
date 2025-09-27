import 'package:flutter/material.dart';
import 'package:petprojectsbookingapp/src/features/auth/presentation/pages/splash.dart';
import 'package:petprojectsbookingapp/src/features/auth/presentation/pages/login_page.dart';
import 'package:petprojectsbookingapp/src/features/home/presentation/pages/main_navigation_wrapper.dart';
import 'package:petprojectsbookingapp/src/core/widgets/auth_gate.dart';

class AppRoutes {
  static const String splash = '/';
  static const String authGate = '/auth';
  static const String login = '/login';
  static const String home = '/home';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.authGate:
        return MaterialPageRoute(builder: (_) => const AuthGate());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LogRegScreen());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const MainNavigationWrapper());
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
