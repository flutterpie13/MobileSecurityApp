import 'package:flutter/material.dart';

import '../api_service.dart';
import '../route_manager/app_localization.dart';

class ScanningScreen extends StatelessWidget {
  final String scanType;
  final String target;

  const ScanningScreen({Key? key, required this.scanType, required this.target})
      : super(key: key);

  Future<Map<String, dynamic>> _performScan() {
    // Hier könntest du einen neuen Endpunkt implementieren, z. B.:
    // GET/POST /scan/perform?scanType=...&target=...
    // Der gibt direkt oder nach kurzer Berechnung die Ergebnisse zurück.
    return ApiService().getScanResults(scanType, target);
    // Falls du einen eigenen Endpunkt für perform brauchst, implementiere den in ApiService.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.getTranslatedText(context, 'scanning')),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _performScan(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Fehler beim Scannen: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red)),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text(AppLocalizations.getTranslatedText(
                    context, 'no_scan_results')));
          } else {
            final results = snapshot.data!;
            // Nachdem der Scan abgeschlossen ist, kannst du direkt zum ResultScreen navigieren
            // oder die Ergebnisse hier darstellen.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamed(context, '/results',
                  arguments: {'scanType': scanType, 'target': target});
            });
            return Center(
                child: Text(AppLocalizations.getTranslatedText(
                    context, 'scan_finished')));
          }
        },
      ),
    );
  }
}
