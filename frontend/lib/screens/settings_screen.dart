import 'package:flutter/material.dart';
import '../api_service.dart';
import '../route_manager/app_localization.dart';

class SettingsScreen extends StatelessWidget {
  final String? userId;
  final Function(Locale) onLocaleChange;

  const SettingsScreen({Key? key, this.userId, required this.onLocaleChange})
      : super(key: key);

  Future<Map<String, dynamic>> _loadSettings() {
    // Falls userId nötig ist:
    final uid = userId ?? 'defaultUserId';
    return ApiService().getUserSettings(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.getTranslatedText(context, 'settings')),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadSettings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text(AppLocalizations.of(context)
                        ?.translate('error_loading_settings') ??
                    'Error loading settings'));
          } else if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  AppLocalizations.getTranslatedText(
                      context, 'change_language'),
                ),
                ElevatedButton(
                    onPressed: () {
                      onLocaleChange(Locale('de'));
                    },
                    child: Text(
                      AppLocalizations.getTranslatedText(context, 'german'),
                    )),
                ElevatedButton(
                    onPressed: () {
                      onLocaleChange(Locale('en'));
                    },
                    child: Text(
                      AppLocalizations.getTranslatedText(context, 'english'),
                    )),
                // Weitere Einstellungen hier anzeigen
              ],
            );
          } else {
            return Center(
                child: Text(AppLocalizations.getTranslatedText(
                    context, 'no_settings_found')));
          }
        },
      ),
    );
  }
}
