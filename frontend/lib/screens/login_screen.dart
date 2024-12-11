import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api_service.dart';
import '../app_theme.dart';
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
    final noAccountLabel =
        AppLocalizations.getTranslatedText(context, 'no_account_register');
    final forgotPasswordLabel =
        AppLocalizations.getTranslatedText(context, 'forgot_password');
    final loginTitle =
        AppLocalizations.getTranslatedText(context, 'login_title');
    final germanLabel = AppLocalizations.getTranslatedText(context, 'german');
    final englishLabel = AppLocalizations.getTranslatedText(context, 'english');

    return Scaffold(
        appBar: AppBar(
          title: Text(loginTitle,
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
                padding: EdgeInsets.all(LayoutConfig.greatPadding),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: emailLabel,
                          labelStyle:
                              TextStyle(fontSize: LayoutConfig.fontSize),
                        ),
                        validator: ValidationUtils.validateEmail,
                        onSaved: (value) => _email = value!,
                        style: TextStyle(fontSize: LayoutConfig.fontSize),
                      ),
                      SizedBox(height: LayoutConfig.spacing),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: passwordLabel,
                          labelStyle:
                              TextStyle(fontSize: LayoutConfig.fontSize),
                        ),
                        obscureText: true,
                        validator: ValidationUtils.validatePassword,
                        onSaved: (value) => _password = value!,
                        style: TextStyle(fontSize: LayoutConfig.fontSize),
                      ),
                      SizedBox(height: LayoutConfig.spacing),
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _submitLogin();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  vertical: LayoutConfig.smallSpacing,
                                  horizontal: LayoutConfig.smallSpacing,
                                ),
                              ),
                              child: Text(loginLabel,
                                  style: TextStyle(
                                      fontSize: LayoutConfig.fontSize)),
                            ),
                      SizedBox(height: LayoutConfig.greatSpacing),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text(
                          noAccountLabel,
                          style: TextStyle(fontSize: LayoutConfig.fontSize),
                        ),
                      ),
                      SizedBox(height: LayoutConfig.smallSpacing),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/forgot-password');
                        },
                        child: Text(
                          forgotPasswordLabel,
                          style: TextStyle(fontSize: LayoutConfig.fontSize),
                        ),
                      ),
                      //SizedBox(height: LayoutConfig.spacing),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () {
                              widget.onLocaleChange(Locale('de'));
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: LayoutConfig.smallSpacing,
                                horizontal: LayoutConfig.spacing,
                              ),
                            ),
                            child: Text(germanLabel,
                                style:
                                    TextStyle(fontSize: LayoutConfig.fontSize)),
                          ),
                          SizedBox(height: LayoutConfig.smallSpacing),
                          TextButton(
                            onPressed: () {
                              widget.onLocaleChange(Locale('en'));
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: LayoutConfig.smallSpacing,
                                horizontal: LayoutConfig.spacing,
                              ),
                            ),
                            child: Text(englishLabel,
                                style:
                                    TextStyle(fontSize: LayoutConfig.fontSize)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ));
        }));
  }
}
