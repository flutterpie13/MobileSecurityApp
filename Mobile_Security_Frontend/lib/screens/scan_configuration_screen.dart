import 'package:flutter/material.dart';

import '../api_service.dart';
import '../utils/validation_utils.dart';
import '../utils/error_handler.dart';

class ScanConfigurationScreen extends StatefulWidget {
  @override
  _ScanConfigurationScreenState createState() =>
      _ScanConfigurationScreenState();
}

class _ScanConfigurationScreenState extends State<ScanConfigurationScreen> {
  final _urlController = TextEditingController();
  final _apiService =
      ApiService(baseUrl: 'https://example.com/api'); // Backend-URL
  bool _isUrlSelected = true;
  bool _isLoading = false;
  List<String> selectedChecks = [];

  final Map<String, List<String>> checkOptions = {
    'App': [
      'Authentication',
      'Data Transfer',
      'Code Injection',
      'API Security',
    ],
    'URL': [
      'Cross-Site Scripting',
      'SQL Injection',
      'Session Management',
      'File Uploads',
      'CSRF Protection',
      'Software Status',
      'Directory Listing',
    ],
  };

  Future<void> _startScan() async {
    if (_isUrlSelected &&
        ValidationUtils.validateURL(_urlController.text) != null) {
      ErrorHandler.showError(context, 'Please enter a valid URL.');
      return;
    }

    if (selectedChecks.isEmpty) {
      ErrorHandler.showError(context, 'Please select at least one check.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final scanType = _isUrlSelected ? 'URL' : 'App';
      final response = await _apiService.scanUrl(
        _isUrlSelected ? _urlController.text : 'app_package_name',
        selectedChecks,
      );

      Navigator.pushNamed(context, '/results', arguments: {
        'scanType': scanType,
        'results': response['results'],
      });
    } catch (e) {
      ErrorHandler.showError(context, e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configure Scan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('URL'),
                    value: true,
                    groupValue: _isUrlSelected,
                    onChanged: (value) {
                      setState(() {
                        _isUrlSelected = value!;
                        selectedChecks.clear();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('App'),
                    value: false,
                    groupValue: _isUrlSelected,
                    onChanged: (value) {
                      setState(() {
                        _isUrlSelected = value!;
                        selectedChecks.clear();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_isUrlSelected)
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(labelText: 'Enter URL'),
              ),
            if (!_isUrlSelected)
              const Text('Select an installed app (Feature coming soon)'),
            const SizedBox(height: 16),
            const Text('Select Checks:'),
            ...checkOptions[_isUrlSelected ? 'URL' : 'App']!.map(
              (check) => CheckboxListTile(
                title: Text(check),
                value: selectedChecks.contains(check),
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      selectedChecks.add(check);
                    } else {
                      selectedChecks.remove(check);
                    }
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _startScan,
                    child: const Text('Start Scan'),
                  ),
          ],
        ),
      ),
    );
  }
}
