import 'package:MobileSecurityApp/api_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Future<Map<String, dynamic>> _loadHomeData() {
    return ApiService().getHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadHomeData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Fehler beim Laden: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red)),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Keine Home-Daten'));
          } else {
            final data = snapshot.data!;
            return Center(
              child: Text(
                  'Willkommen! Daten: ${data['welcomeMessage'] ?? 'Hallo'}'),
            );
          }
        },
      ),
    );
  }
}
