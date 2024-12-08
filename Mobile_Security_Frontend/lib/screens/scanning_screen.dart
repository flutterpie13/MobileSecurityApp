import 'package:flutter/material.dart';

import '../api_service.dart';
import '../utils/error_handler.dart';

class ScanningScreen extends StatefulWidget {
  final String scanType;
  final String target;
  final List<String> selectedChecks;

  const ScanningScreen({
    Key? key,
    required this.scanType,
    required this.target,
    required this.selectedChecks,
  }) : super(key: key);

  @override
  _ScanningScreenState createState() => _ScanningScreenState();
}

class _ScanningScreenState extends State<ScanningScreen> {
  final _apiService =
      ApiService(baseUrl: 'https://example.com/api'); // Backend-URL
  int _currentStep = 0;
  bool _isScanning = true;
  bool _hasError = false;
  Map<String, String> _results = {};

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  Future<void> _startScan() async {
    try {
      for (int i = 0; i < widget.selectedChecks.length; i++) {
        setState(() {
          _currentStep = i;
        });

        final response = await _apiService.performCheck(
          widget.scanType,
          widget.target,
          widget.selectedChecks[i],
        );

        setState(() {
          _results[widget.selectedChecks[i]] = response['status'];
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
      });
      ErrorHandler.showError(context, e.toString());
    } finally {
      setState(() {
        _isScanning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanning...'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isScanning
            ? Column(
                children: [
                  const Text(
                    'Scanning in progress...',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: (_currentStep + 1) / widget.selectedChecks.length,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Currently checking: ${widget.selectedChecks[_currentStep]}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              )
            : _hasError
                ? const Center(
                    child: Text('An error occurred during scanning.'))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Scan Complete',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _results.length,
                          itemBuilder: (context, index) {
                            final check = widget.selectedChecks[index];
                            final status = _results[check];
                            return ListTile(
                              title: Text(check),
                              trailing: Icon(
                                status == 'Pass'
                                    ? Icons.check_circle
                                    : Icons.error,
                                color: status == 'Pass'
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            );
                          },
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/results', arguments: {
                            'scanType': widget.scanType,
                            'target': widget.target,
                            'results': _results,
                          });
                        },
                        child: const Text('View Results'),
                      ),
                    ],
                  ),
      ),
    );
  }
}
