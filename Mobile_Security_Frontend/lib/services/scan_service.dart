import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

Future<Map<String, dynamic>> performScan(String scanType, String target) async {
  final url = Uri.parse('${ApiConfig.baseUrl}/scan/perform');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'scan_type': scanType, 'target': target}),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to perform scan: ${response.body}');
  }
}
