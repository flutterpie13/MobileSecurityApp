import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api_service.dart';
import '../route_manager/app_localization.dart';
import '../state/app_state_secure.dart';
import '../utils/validation_utils.dart';
import '../utils/error_handler.dart';

class LoginScreen extends StatefulWidget {
  final Function(Locale) onLocaleChange;
  const LoginScreen({Key? key, required this.onLocaleChange}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService(); // Lokale Backend-URL
  String _email = '';
  String _password = '';
  bool _isLoading = false;

  Future<void> _submitLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Login über den ApiService
        _formKey.currentState!.save();
        final response = await _apiService.login(_email, _password);

        // Token und Benutzerinformationen speichern
        final appState = Provider.of<AppState>(context, listen: false);
        await appState.setUserEmail(_email);
        await appState
            .saveToken(response['user_id']); // Beispiel: Token speichern

        // Weiterleitung nach erfolgreichem Login
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        ErrorHandler.showError(context, e.toString());
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailLabel = AppLocalizations.getTranslatedText(context, 'email');
    final passwordLabel =
        AppLocalizations.getTranslatedText(context, 'password');
    final loginLabel = AppLocalizations.getTranslatedText(context, 'login');
    final germanLabel = AppLocalizations.getTranslatedText(context, 'german');
    final englishLabel = AppLocalizations.getTranslatedText(context, 'english');
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.getTranslatedText(context, 'login_title')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: emailLabel),
                validator: ValidationUtils.validateEmail,
                onSaved: (value) => _email = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: passwordLabel),
                obscureText: true,
                validator: ValidationUtils.validatePassword,
                onSaved: (value) => _password = value!,
              ),
              const SizedBox(height: 16),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _submitLogin();
                        }
                      },
                      child: Text(loginLabel),
                    ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text(AppLocalizations.getTranslatedText(
                    context, 'no_account_register')),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/forgot-password');
                },
                child: Text(AppLocalizations.getTranslatedText(
                    context, 'forgot_password')),
              ),
              const SizedBox(height: 50),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                TextButton(
                  onPressed: () {
                    widget.onLocaleChange(const Locale('de'));
                  },
                  child: Text(germanLabel),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    widget.onLocaleChange(const Locale('en'));
                  },
                  child: Text(englishLabel),
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }
}
