import 'package:flutter/material.dart';
import '../api_service.dart';
import '../route_manager/app_localization.dart';

class LoginScreen extends StatefulWidget {
  final Function(Locale) onLocaleChange;

  const LoginScreen({Key? key, required this.onLocaleChange}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _errorMessage;

  void _login() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final result = await ApiService()
          .login(_emailController.text, _passwordController.text);
      // success -> Access Token etc. verwenden
      Navigator.pushNamed(context, '/home');
    } catch (e) {
      setState(() {
        _errorMessage = 'Login fehlgeschlagen: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.getTranslatedText(context, 'login')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  if (_errorMessage != null)
                    Text(_errorMessage!,
                        style: const TextStyle(color: Colors.red)),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        labelText: AppLocalizations.getTranslatedText(
                            context, 'email')),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                        labelText: AppLocalizations.getTranslatedText(
                            context, 'password')),
                    obscureText: true,
                  ),
                  if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  if (_loading)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton(
                      onPressed: _login,
                      child: Text(
                          AppLocalizations.getTranslatedText(context, 'login')),
                    ),
                  ElevatedButton(
                      onPressed: () {
                        widget.onLocaleChange(Locale('de'));
                      },
                      child: Text(
                        AppLocalizations.getTranslatedText(context, 'german'),
                      )),
                  ElevatedButton(
                      onPressed: () {
                        widget.onLocaleChange(Locale('en'));
                      },
                      child: Text(
                        AppLocalizations.getTranslatedText(context, 'english'),
                      )),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text(AppLocalizations.getTranslatedText(
                        context, 'no_account')),
                  ),
                ],
              ),
      ),
    );
  }
}
