import 'package:MobileSecurityApp/api_service.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({Key? key}) : super(key: key);

  Future<Map<String, dynamic>> _loadDetails(String checkName) {
    return ApiService(
            baseUrl: 'http://localhost:5000/scan/details?checkName=$checkName')
        .getCheckDetails(checkName);
  }

  @override
  Widget build(BuildContext context) {
    // Arguments aus der Navigation holen
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final checkName = args['checkName'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadDetails(checkName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Während die Daten geladen werden, Lade-Indicator anzeigen
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Fehlerfall anzeigen
            return Center(
              child: Text(
                'Fehler beim Laden: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData) {
            // Keine Daten vorhanden
            return const Center(child: Text('Keine Daten vorhanden'));
          } else {
            // Erfolgsfall: Daten liegen vor
            final data = snapshot.data!;
            final status = data['status'] ?? 'Unbekannt';
            final recommendations =
                data['recommendations'] ?? 'Keine Empfehlungen verfügbar';

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    checkName,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        'Status: ',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        status,
                        style: TextStyle(
                          fontSize: 18,
                          color: status == 'Pass' ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Recommendations:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        recommendations,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Back to Results'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
