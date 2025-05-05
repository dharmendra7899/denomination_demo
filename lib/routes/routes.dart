import 'package:denomination/routes/routes_names.dart';
import 'package:denomination/screens/history/denomination_history.dart';
import 'package:denomination/screens/home/home_screen.dart';
import 'package:denomination/screens/splash/splash.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RouteNames.dashboardScreen:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case RouteNames.historyScreen:
        return MaterialPageRoute(builder: (_) => const DenominationHistory());
      default:
        return MaterialPageRoute(
          builder:
              (_) => const Scaffold(
                body: Center(child: Text("No route is configured")),
              ),
        );
    }
  }
}
