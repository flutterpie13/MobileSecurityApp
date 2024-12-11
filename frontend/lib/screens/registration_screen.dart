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

  void _register() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final result = await ApiService().register(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      // Angenommen das result beinhaltet {'message': 'User registered successfully.'}
      // Nach erfolgreicher Registrierung kann man z. B. zum Login navigieren:
      Navigator.pushNamed(context, '/login');
    } catch (e) {
      setState(() {
        _errorMessage = 'Registrierung fehlgeschlagen: $e';
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
        title: Text(AppLocalizations.getTranslatedText(context, 'register')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
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
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                        labelText: AppLocalizations.getTranslatedText(
                            context, 'password')),
                    obscureText: true,
                  ),
                  const SizedBox(height: 25),
                  TextField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.getTranslatedText(
                          context, 'confirm_password'),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: _register,
                    child: Text(AppLocalizations.getTranslatedText(
                        context, 'register')),
                  ),
                ],
              ),
      ),
    );
  }
}
