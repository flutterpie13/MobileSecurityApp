import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'route_manager.dart';
import 'secure_storage/token_manager.dart';
import 'app_entry.dart';
import 'state/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final TokenManager tokenManager = TokenManager();
  final token = await tokenManager.loadToken();

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
