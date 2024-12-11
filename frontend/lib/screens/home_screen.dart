import 'package:flutter/material.dart';
import '../api_service.dart';
import '../route_manager/app_localization.dart';

class HomeScreen extends StatelessWidget {
  final Function(Locale) onLocaleChange;

  HomeScreen({required this.onLocaleChange});

  Future<Map<String, dynamic>> _loadHomeData() {
    // Implementiere hier die Logik zum Laden der Home-Daten
    return ApiService().getHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.getTranslatedText(context, 'home')),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadHomeData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(AppLocalizations.of(context)
                      ?.translate('error_loading_data') ??
                  'Error loading data'),
            );
          } else if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(AppLocalizations.getTranslatedText(
                    context, 'welcome_home')),
                ElevatedButton(
                  onPressed: () {
                    onLocaleChange(Locale('de'));
                  },
                  child: Text('Deutsch'),
                ),
                ElevatedButton(
                  onPressed: () {
                    onLocaleChange(Locale('en'));
                  },
                  child: Text('English'),
                ),
                // Weitere Widgets, die die geladenen Daten anzeigen
              ],
            );
          } else {
            return Center(
              child: Text(
                  AppLocalizations.getTranslatedText(context, 'no_data_found')),
            );
          }
        },
      ),
    );
  }
}
