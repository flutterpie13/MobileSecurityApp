import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://localhost:5000';
  // In der lokalen Entwicklung wäre das dein lokaler Server.
  // Später anpassen, wenn du einen richtigen Server/Domain hast.

  Future<Map<String, dynamic>> getScanResults(
      String scanType, String target) async {
    final url = '$baseUrl/scan/results?scanType=$scanType&target=$target';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(jsonDecode(response.body));
    } else {
      throw Exception(
          'Fehler beim Laden der Scan-Ergebnisse: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getCheckDetails(String checkName) async {
    final url = '$baseUrl/scan/details?checkName=$checkName';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(jsonDecode(response.body));
    } else {
      throw Exception(
          'Fehler beim Laden der Detailinformationen: ${response.statusCode}');
    }
  }

  Future<List<dynamic>> getHistory() async {
    final url = '$baseUrl/scan/history';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return List<dynamic>.from(jsonDecode(response.body));
    } else {
      throw Exception('Fehler beim Laden der History: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getScanConfigurationOptions() async {
    final url = '$baseUrl/scan/config-options';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(jsonDecode(response.body));
    } else {
      throw Exception(
          'Fehler beim Laden der Scan-Konfiguration: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getUserSettings(String userId) async {
    final url = '$baseUrl/user/settings?userId=$userId';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(jsonDecode(response.body));
    } else {
      throw Exception(
          'Fehler beim Laden der Einstellungen: ${response.statusCode}');
    }
  }

  // Falls HomeScreen Daten lädt:
  Future<Map<String, dynamic>> getHomeData() async {
    final url = '$baseUrl/home/data';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(jsonDecode(response.body));
    } else {
      throw Exception(
          'Fehler beim Laden der Home-Daten: ${response.statusCode}');
    }
  }

  // Beispiel für Authentifizierung:
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = '$baseUrl/auth/login';
    final response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}));
    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(jsonDecode(response.body));
    } else {
      throw Exception('Login fehlgeschlagen: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> register(String email, String password) async {
    final url = '$baseUrl/auth/register';
    final response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}));
    if (response.statusCode == 201) {
      return Map<String, dynamic>.from(jsonDecode(response.body));
    } else {
      throw Exception('Registrierung fehlgeschlagen: ${response.statusCode}');
    }
  }
}
