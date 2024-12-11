import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mobile_security_app/route_manager.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'app_theme.dart';
import 'route_manager/app_localization.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/settings_screen.dart';
import 'secure_storage/token_manager.dart';
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

  const MyApp({required this.startRoute});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  void _changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      // Hier LayoutConfig initialisieren
      LayoutConfig.init(context);
      return MaterialApp(
        locale: _locale,
        theme: ThemeData.dark(),
        supportedLocales: const [Locale('en', 'US'), Locale('de', 'DE')],
        localizationsDelegates: const [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        initialRoute: widget.startRoute,
        onGenerateRoute: RouteManager.generateRoute,
      );
    });
  }
}
