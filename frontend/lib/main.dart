import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'route_manager.dart';
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

class MyApp extends StatelessWidget {
  final String startRoute;

  const MyApp({Key? key, required this.startRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Security App',
      theme: ThemeData.dark(),
      onGenerateRoute: RouteManager.generateRoute,
      builder: (context, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamed(context, startRoute);
        });
        return child!;
      },
    );
  }
}
