import 'package:denomination/routes/routes.dart';
import 'package:denomination/routes/routes_names.dart';
import 'package:denomination/theme/theme.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme: AppTheme.lightThemeMode,
      darkTheme: AppTheme.darkThemeMode,
      locale: Locale('en'),
      debugShowCheckedModeBanner: false,
      initialRoute: RouteNames.splashScreen,
      onGenerateRoute: Routes.generateRoutes,
    );
  }
}
