import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:holdemmanager_app/Helpers/languageHelper.dart';
import 'package:holdemmanager_app/Screens/home_screen.dart';
import 'package:holdemmanager_app/Screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TranslationService {
  static final TranslationService _instance = TranslationService._internal();
  late Map<String, dynamic> _translations;
  Locale? _locale;
  Locale? _localeAnterior;

  TranslationService._internal();

  factory TranslationService() {
    return _instance;
  }

  Future<Map<String, dynamic>> getTranslations() async {
    String data =
        await rootBundle.loadString('lib/assets/locales/traducciones.json');
    return _translations = json.decode(data);
  }

  Map<String, dynamic> get translations => _translations;

  Future<void> setLocale(Locale locale, BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String languageCode = prefs.getString('languageCode') ?? 'en';
    String countryCode = prefs.getString('countryCode') ?? 'US';

    await prefs.setString('languageCode', locale.languageCode);
    await prefs.setString('countryCode', locale.countryCode ?? '');

    _localeAnterior = Locale(languageCode, countryCode);
    _locale = locale;

    mostrarRestartDialog(context);
  }

  Locale get locale => _locale!;

  Future<Locale?> getLocale() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('languageCode');
    String? countryCode = prefs.getString('countryCode');

    if (languageCode != null && languageCode.isNotEmpty) {
      return Locale(languageCode, countryCode);
    }
    return const Locale('en', 'US');
  }

  void mostrarRestartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              _translations[_locale.toString()]?['restartTitle'] ??
                  'Restart Required',
              textAlign: TextAlign.center,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  _translations[_locale.toString()]?['restartMessage'] ??
                      'The application needs to restart to apply the new language.',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () async {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      await prefs.setString(
                          'languageCode', _localeAnterior!.languageCode);
                      await prefs.setString(
                          'countryCode', _localeAnterior!.countryCode!);
                      _locale = _localeAnterior;
                      _localeAnterior = null;
                      notificarCambioLenguaje();
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.orangeAccent),
                    ),
                    child: Text(
                      _translations[_locale.toString()]?['cancel'] ?? 'Cancel',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      mostrarDialogoDeCarga(context);
                      reiniciarAplicacionYRedirigir(context);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.orangeAccent),
                    ),
                    child: Text(
                      _translations[_locale.toString()]?['restart'] ??
                          'Restart',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void mostrarDialogoDeCarga(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: const Stack(
            children: <Widget>[
              Center(
                child: SizedBox(
                  width: 50.0,
                  height: 50.0,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.orangeAccent),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void reiniciarAplicacionYRedirigir(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route<dynamic> route) => false,
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  void notificarCambioLenguaje() {
    for (var widget in _listeners) {
      widget.actualizarLenguaje(_locale!);
    }
  }

  final List<LanguageHelper> _listeners = [];

  void addListener(LanguageHelper widget) {
    _listeners.add(widget);
  }

  void removeListener(LanguageHelper widget) {
    _listeners.remove(widget);
  }
}
