import 'package:MobileSecurityApp/api_service.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  Future<List<dynamic>> _loadHistory() {
    return ApiService().getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _loadHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Fehler beim Laden: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red)),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Keine Scans in der History'));
          } else {
            final history = snapshot.data!;
            return ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                // Erwartet: item = { "id": ..., "scan_type": ..., "target": ..., "created_at": ..., "results": ... }
                return ListTile(
                  title: Text('Scan ${item['id']}: ${item['scan_type']}'),
                  subtitle:
                      Text('Target: ${item['target']} - ${item['created_at']}'),
                  onTap: () {
                    Navigator.pushNamed(context, '/results', arguments: {
                      'scanType': item['scan_type'],
                      'target': item['target']
                    });
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
