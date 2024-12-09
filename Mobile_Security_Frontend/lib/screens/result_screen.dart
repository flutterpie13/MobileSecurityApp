import 'package:MobileSecurityApp/api_service.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ResultScreen extends StatelessWidget {
  final String scanType;
  final String target;

  const ResultScreen({
    Key? key,
    required this.scanType,
    required this.target,
    required results,
  }) : super(key: key);

  Future<void> _exportPDF(
      BuildContext context, Map<String, String> results) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Scan Results',
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.Text('Scan Type: $scanType'),
              pw.Text('Target: $target'),
              pw.Divider(),
              ...results.entries.map((entry) {
                return pw.Text('${entry.key}: ${entry.value}');
              }).toList(),
            ],
          );
        },
      ),
    );

    await Printing.sharePdf(
        bytes: await pdf.save(), filename: 'scan_results.pdf');
  }

  Future<Map<String, String>> _loadResults() {
    return ApiService(
            baseUrl:
                'http://localhost:5000/scan/results?scanType=$scanType&target=$target')
        .getScanResults(scanType, target);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Results'),
      ),
      body: FutureBuilder<Map<String, String>>(
        future: _loadResults(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Während die Daten geladen werden
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Fehlerfall anzeigen
            return Center(
              child: Text(
                'Fehler beim Laden: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Keine Daten vorhanden
            return const Center(child: Text('Keine Daten'));
          } else {
            // Erfolgsfall: Daten liegen vor
            final results = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Scan Results',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final checkName = results.keys.elementAt(index);
                        final status = results[checkName];
                        return ListTile(
                          title: Text(checkName),
                          trailing: Icon(
                            status == 'Pass' ? Icons.check_circle : Icons.error,
                            color: status == 'Pass' ? Colors.green : Colors.red,
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/details',
                              arguments: {
                                'checkName': checkName,
                                'status': status,
                                'recommendations':
                                    'Details and recommendations for $checkName.',
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _exportPDF(context, results),
                    child: const Text('Export as PDF'),
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
