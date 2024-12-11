import 'package:flutter/material.dart';
import 'package:mobile_security_app/api_service.dart';

import '../app_theme.dart';
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
          title: Text(registerLabel,
              style: TextStyle(fontSize: LayoutConfig.fontSize * 1.2)),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
              child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight, // Füllt den verfügbaren Platz
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: EdgeInsets.all(LayoutConfig.padding),
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (_errorMessage != null)
                            Text(
                              _errorMessage!,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: LayoutConfig.fontSize),
                            ),
                          SizedBox(height: LayoutConfig.spacing),
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: emailLabel,
                              labelStyle:
                                  TextStyle(fontSize: LayoutConfig.fontSize),
                            ),
                            style: TextStyle(fontSize: LayoutConfig.fontSize),
                          ),
                          SizedBox(height: LayoutConfig.spacing),
                          TextField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: passwordLabel,
                              labelStyle:
                                  TextStyle(fontSize: LayoutConfig.fontSize),
                            ),
                            obscureText: false,
                            style: TextStyle(fontSize: LayoutConfig.fontSize),
                          ),
                          SizedBox(height: LayoutConfig.spacing),
                          TextField(
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              labelText: confirmPasswordLabel,
                              labelStyle:
                                  TextStyle(fontSize: LayoutConfig.fontSize),
                            ),
                            obscureText: false,
                            style: TextStyle(fontSize: LayoutConfig.fontSize),
                          ),
                          SizedBox(height: LayoutConfig.spacing),
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
                              Expanded(
                                child: Text(
                                  over18Label,
                                  style: TextStyle(
                                      fontSize: LayoutConfig.fontSize),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: LayoutConfig.smallSpacing),
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
                              Expanded(
                                child: Text(
                                  termsLabel,
                                  style: TextStyle(
                                      fontSize: LayoutConfig.fontSize),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: LayoutConfig.spacing),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: _isFormValid() ? _register : null,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: LayoutConfig.smallSpacing,
                                horizontal: LayoutConfig.spacing,
                              ),
                            ),
                            child: Text(registerLabel,
                                style:
                                    TextStyle(fontSize: LayoutConfig.fontSize)),
                          ),
                        ],
                      ),
              ),
            ),
          ));
        }));
  }
}
