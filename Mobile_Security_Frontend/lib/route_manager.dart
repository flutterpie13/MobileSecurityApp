import 'package:flutter/material.dart';
import 'screens/detail_screen.dart';
import 'screens/history_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/result_screen.dart';
import 'screens/scan_configuration_screen.dart';
import 'screens/scanning_screen.dart';
import 'screens/settings_screen.dart';

class RouteManager {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegistrationScreen());
      case '/settings':
        // Falls wir z. B. eine userId mitgeben:
        final args = settings.arguments as Map<String, dynamic>?;
        final userId = args?['userId'];
        return MaterialPageRoute(
          builder: (_) => SettingsScreen(userId: userId),
        );
      case '/scan-config':
        return MaterialPageRoute(
            builder: (_) => const ScanConfigurationScreen());
      case '/scanning':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ScanningScreen(
            scanType: args['scanType'],
            target: args['target'],
          ),
        );
      case '/results':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ResultScreen(
            scanType: args['scanType'],
            target: args['target'],
          ),
        );
      case '/history':
        return MaterialPageRoute(builder: (_) => const HistoryScreen());
      case '/details':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => DetailScreen(checkName: args['checkName']),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('404 - Screen not found'),
            ),
          ),
        );
    }
  }
}
