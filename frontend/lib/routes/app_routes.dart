import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/home_screen.dart';
import '../screens/search_screen.dart';

/// Centralized route names + route table for the app.
/// Keeping these as constants avoids typos like Navigator.pushNamed(context, '/serach').
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String home = '/home';
  static const String search = '/search';

  /// Static route table — use this for routes that don't need arguments passed in.
  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    home: (context) => const HomeScreen(),
    search: (context) => const SearchScreen(),
  };

  /// Optional: onGenerateRoute handles routes that need arguments, or any
  /// route not found in the static table above (falls back to a 404 screen
  /// instead of crashing).
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
            builder: (_) => const SplashScreen(), settings: settings);
      case home:
        return MaterialPageRoute(
            builder: (_) => const HomeScreen(), settings: settings);
      case search:
        return MaterialPageRoute(
            builder: (_) => const SearchScreen(), settings: settings);
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body:
                Center(child: Text('No route defined for "${settings.name}"')),
          ),
          settings: settings,
        );
    }
  }
}
