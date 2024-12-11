import 'package:flutter/material.dart';
import 'package:mobile_security_app/api_service.dart';

import '../route_manager/app_localization.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Controller für das Bestätigungsfeld
  // toDo ändern
  final _confirmPasswordController = TextEditingController();
  bool _loading = false;
  String? _errorMessage;
  bool _over18 = false;
  bool _acceptedTerms = false;

  void _register() async {
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    if (password != confirmPassword) {
      setState(() {
        _errorMessage = AppLocalizations.getTranslatedText(
            context, 'passwords_do_not_match');
      });
      return;
    }

    if (!_over18) {
      setState(() {
        _errorMessage =
            AppLocalizations.getTranslatedText(context, 'must_be_over_18');
      });
      return;
    }

    if (!_acceptedTerms) {
      setState(() {
        _errorMessage =
            AppLocalizations.getTranslatedText(context, 'must_accept_terms');
      });
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final result = await ApiService().register(
        _emailController.text.trim(),
        password,
      );
      // Nach erfolgreicher Registrierung zum Login navigieren
      Navigator.pushNamed(context, '/login');
    } catch (e) {
      setState(() {
        _errorMessage =
            '${AppLocalizations.getTranslatedText(context, 'registration_failed')}: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  bool _isFormValid() {
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    return password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        password == confirmPassword &&
        _over18 &&
        _acceptedTerms;
  }

  @override
  Widget build(BuildContext context) {
    final registerLabel =
        AppLocalizations.getTranslatedText(context, 'register');
    final emailLabel = AppLocalizations.getTranslatedText(context, 'email');
    final passwordLabel =
        AppLocalizations.getTranslatedText(context, 'password');
    final confirmPasswordLabel =
        AppLocalizations.getTranslatedText(context, 'confirm_password');
    final over18Label = AppLocalizations.getTranslatedText(context, 'over_18');
    final termsLabel =
        AppLocalizations.getTranslatedText(context, 'accept_terms');
    return Scaffold(
      appBar: AppBar(
        title: Text(registerLabel),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_errorMessage != null)
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: emailLabel),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: passwordLabel),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _confirmPasswordController,
                      decoration:
                          InputDecoration(labelText: confirmPasswordLabel),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: _over18,
                          onChanged: (val) {
                            setState(() {
                              _over18 = val ?? false;
                            });
                          },
                        ),
                        Expanded(child: Text(over18Label)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Checkbox(
                          value: _acceptedTerms,
                          onChanged: (val) {
                            setState(() {
                              _acceptedTerms = val ?? false;
                            });
                          },
                        ),
                        Expanded(child: Text(termsLabel)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isFormValid() ? _register : null,
                      child: Text(registerLabel),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
