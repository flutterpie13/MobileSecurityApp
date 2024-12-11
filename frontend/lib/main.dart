import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'route_manager.dart';
import 'route_manager/app_localization.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/settings_screen.dart';
import 'secure_storage/token_manager.dart';
import 'app_entry.dart';
import 'state/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final TokenManager tokenManager = TokenManager();
  final token = await tokenManager.loadToken();
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return const Material(
      child: Center(
        child: Text(
          'Ein unerwarteter Fehler ist aufgetreten.',
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  };

  runZonedGuarded(() {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppState()),
        ],
        child: MyApp(
          startRoute: token == null ? '/login' : '/home',
        ),
      ),
    );
  }, (error, stackTrace) {
    // Hier kannst du Logging-Mechanismen einbauen oder Sentry integrieren.
    print('Uncaught error: $error');
  });
}

class MyApp extends StatefulWidget {
  final String startRoute;

  MyApp({required this.startRoute});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale('en');

  void _changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('de', 'DE'),
      ],
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      initialRoute: widget.startRoute,
      routes: {
        '/login': (context) => LoginScreen(onLocaleChange: _changeLanguage),
        '/home': (context) => HomeScreen(onLocaleChange: _changeLanguage),
        '/settings': (context) =>
            SettingsScreen(onLocaleChange: _changeLanguage),
      },
    );
  }
}
