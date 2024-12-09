import 'package:flutter/material.dart';

import '../api_service.dart';
import '../utils/error_handler.dart';

import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final String? userId;

  const SettingsScreen({Key? key, this.userId}) : super(key: key);

  Future<Map<String, dynamic>> _loadSettings() {
    // Falls userId nötig ist:
    final uid = userId ?? 'defaultUserId';
    return ApiService().getUserSettings(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadSettings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Fehler beim Laden: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red)),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Keine Einstellungen verfügbar'));
          } else {
            final settings = snapshot.data!;
            // Zeige Settings an, z. B.:
            return ListView(
              children: [
                ListTile(
                  title: Text('Theme: ${settings['theme']}'),
                ),
                // Weitere Settings...
              ],
            );
          }
        },
      ),
    );
  }
}
