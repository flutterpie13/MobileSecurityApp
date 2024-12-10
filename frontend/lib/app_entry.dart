import 'package:flutter/material.dart';
import 'route_manager.dart';

class MobileSecurityApp extends StatelessWidget {
  const MobileSecurityApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Security App',
      theme: ThemeData.dark(),

      onGenerateRoute: RouteManager.generateRoute, // Dynamisches Routing
    );
  }
}
