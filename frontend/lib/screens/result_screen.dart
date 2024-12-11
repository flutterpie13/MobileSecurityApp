import 'package:flutter/material.dart';
import 'package:mobile_security_app/api_service.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../route_manager/app_localization.dart';

class ResultScreen extends StatelessWidget {
  final String scanType;
  final String target;

  const ResultScreen({Key? key, required this.scanType, required this.target})
      : super(key: key);

  Future<void> _exportPDF(
      BuildContext context, Map<String, dynamic> results) async {
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

  Future<Map<String, dynamic>> _loadResults() {
    return ApiService().getScanResults(scanType, target);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(AppLocalizations.getTranslatedText(context, 'scan_results')),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadResults(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Fehler beim Laden: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red)),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text(
                    AppLocalizations.getTranslatedText(context, 'no_data')));
          } else {
            final results = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                      AppLocalizations.getTranslatedText(
                          context, 'scan_results'),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
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
                              arguments: {'checkName': checkName},
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _exportPDF(context, results),
                    child: Text(AppLocalizations.getTranslatedText(
                        context, 'export_pdf')),
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
